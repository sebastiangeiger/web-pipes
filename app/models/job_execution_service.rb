require_relative '../../lib/web_pipes'

class JobExecutionService
  def initialize(job)
    @code = job.code
  end

  def execute
    executor.register(:console, console)
    protocol = executor.execute(@code)
    if protocol.successful?
      Result.new(output: console.to_a, status: :success)
    else
      Result.new(output: protocol.errors.map(&:message), status: :errored)
    end
  end

  private

  def executor
    @executor ||= WebPipes::JavascriptExecutor.new
  end

  def console
    @console ||= Console.new
  end

  class Result
    attr_reader :output, :status
    def initialize(output: '', status: '')
      @output = output
      @status = status
    end
  end

  class Console
    def initialize
      @log = []
    end

    def log(message)
      @log << message
    end

    def to_a
      @log
    end
  end
end
