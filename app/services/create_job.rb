# frozen_string_literal: true

# TODO: documentation is missing for this class
# We should consider addig some documentation here
class CreateJob
  def self.call(current_user, job_params)
    job = current_user ? current_user.jobs.build(job_params) : Job.new(job_params)
    job.token = TokenGenerator.generate
    job
  end
end
