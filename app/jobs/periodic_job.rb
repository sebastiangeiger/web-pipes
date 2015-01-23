class PeriodicJob < ActiveJob::Base
  queue_as :default

  def perform(*_args)
    # Do something later
  end
end
