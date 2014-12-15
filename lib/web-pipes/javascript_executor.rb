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

    class Error < StandardError
      extend Forwardable

      def_delegators :@original_error, :backtrace, :message, :cause

      def self.from(error)
        new(error)
      end

      def initialize(original_error)
        @original_error = original_error
      end

      def location
        Location.new(self)
      end

      class Location
        EVAL_ERROR_REGEX = /at \<eval\>:(\d+):(\d+)/

        def initialize(error)
          @error = error
        end

        def line
          eval_error do |match|
            Integer(match[1])
          end
        end

        def column
          eval_error do |match|
            Integer(match[2])
          end
        end

        private
        def eval_error(&block)
          eval_error = @error.backtrace.first
          if eval_error =~ EVAL_ERROR_REGEX
            block.call(eval_error.match(EVAL_ERROR_REGEX))
          else
            nil
          end
        end

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
          @result = convert(block.call)
        rescue V8::Error => error
          @errors << JavascriptExecutor::Error.from(error)
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
