module WebPipes
  class JavascriptExecutor
    def initialize
      @context = V8::Context.new
      @context['pivotal'] = PivotalTracker.new
      @context['console'] = STDOUT
    end

    def execute(script)
      Protocol.new.protocol do
        @context.eval(script)
      end
    end

    class Protocol
      attr_accessor :result, :errors

      def initialize
        @errors = []
        @executed = false
      end

      def protocol(&block)
        begin
          @result = block.call
        rescue V8::Error => e
          @errors << e
        end
        @executed = true
        self
      end

      def executed?
        !!@executed
      end

      def successful?
        executed? and @errors.empty?
      end
    end
  end
end
