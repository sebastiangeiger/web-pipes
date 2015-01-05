class JobExecutionService
  def initialize(job)
    @code = job.code
  end

  def execute
    Result.new
  end

  private

  class Result
    def output
      ''
    end
    def status
      ''
    end
  end
end
