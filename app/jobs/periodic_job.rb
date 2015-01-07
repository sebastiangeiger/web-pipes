class PeriodicJob < ActiveJob::Base
  queue_as :default

  def perform(job)
    result = JobExecutionService.new(job).execute
    result.tap(&:save)
  end
end
