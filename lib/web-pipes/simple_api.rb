require 'json'

RequestFailedError = Class.new(StandardError)

class SimpleApi

  private

  def self.request(name, &block)
    name = camel_case_lower(name)
    define_method(name, -> do
      result = block.call
      if result.success?
        JSON.parse(result.body)
      else
        raise RequestFailedError.new("#{name} returned a #{result.status} status")
      end
    end)
  end

  def self.camel_case_lower(method_name)
    method_name.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end
end

