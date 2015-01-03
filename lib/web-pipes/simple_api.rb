require 'json'

RequestFailedError = Class.new(StandardError)

class SimpleApi
  def self.request(name, &block)
    name = camel_case_lower(name)
    define_method(name, lambda do
      result = block.call
      if result.success?
        JSON.parse(result.body)
      else
        fail RequestFailedError, "#{name} returned a #{result.status} status"
      end
    end)
  end

  def self.camel_case_lower(method_name)
    method_name.to_s.split('_').inject([]) do |buffer, element|
      buffer.push(buffer.empty? ? element : element.capitalize)
    end.join
  end
end
