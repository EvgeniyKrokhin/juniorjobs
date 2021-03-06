# frozen_string_literal: true

# Decorate methods for Job model. Example: @jobs = Job.all.decorate
class JobDecorator < ApplicationDecorator
  delegate_all

  EXPIRED_INTERVALS = %w[
    1_week
    2_week
    1_month
  ].freeze

  def expiration
    Date.today < object.expired_at ? t('decorators.job.active_status') : t('decorators.job.expired_status')
  end

  def salary
    if salary_by_agreement
      t('activerecord.attributes.job.salary_by_agreement')
    else
      salary_range = [salary_from, salary_to].compact.map do |salary|
        number_with_delimiter(salary)
      end

      salary_range.join(' - ')
    end
  end

  def location
    city + ' ' + (remote ? + ' / ' + t('activerecord.attributes.job.remote') : '')
  end

  def country_name
    CountryUtility.translate(country)
  end

  def expired_at_dates
    EXPIRED_INTERVALS.map { |interval| expired_at_for(interval) }
  end

  def expired_at_for(modifier)
    interval = TimeUtility.parse_interval(modifier)
    date = (persisted? ? created_at.to_date : Date.current) + interval
    text = t("activerecord.attributes.job.expired_ats.#{modifier}", date: date.strftime('%d/%m/%Y'))
    [text, date]
  end
end
