module WebPipes
  class JavascriptExecutor
    def initialize
      @context = V8::Context.new
    end

    def execute(script)
      Protocol.new.protocol do
        @context.eval(script)
      end
    end

    def register(context_name, instance)
      @context[context_name.to_s] = instance
    end

    class Protocol
      attr_accessor :result, :errors

      def initialize
        @errors = []
        @executed = false
      end

      def protocol(&block)
        begin
          @result = convert(block.call)
        rescue V8::Error => e
          @errors << e
        end
        @executed = true
        self
      end

      def executed?
        !!@executed
      end

      def convert(v8_object)
        if v8_object.is_a? V8::Array
          v8_object.to_a
        else
          v8_object
        end
      end

      def successful?
        executed? and @errors.empty?
      end
    end
  end
end
