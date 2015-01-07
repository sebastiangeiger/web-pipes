require_relative '../../lib/web_pipes'

class JobExecutionService
  def initialize(job)
    @job = job
    @code = job.code
  end

  def execute
    executor.register(:console, console)
    protocol = executor.execute(@code)
    if protocol.successful?
      ExecutionResult.new(job: @job, messages: console.to_a, status: :success)
    else
      messages = protocol.errors.map(&:message)
      ExecutionResult.new(job: @job, messages: messages, status: :errored)
    end
  end

  private

  def executor
    @executor ||= WebPipes::JavascriptExecutor.new
  end

  def console
    @console ||= Console.new
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
