require 'rspec'
require 'webmock/rspec'
require 'pry'
require_relative '../../lib/web-pipes'

describe 'Executing Javascript' do
  subject(:protocol) { executor.execute(script) }
  let(:executor) { WebPipes::JavascriptExecutor.new }
  let(:result) { protocol.result }
  let(:errors) { protocol.errors }
  let(:error) { protocol.errors.first }

  context 'when script succeeds' do
    let(:script) { '"abcd".length' }
    it { is_expected.to be_successful }
    it { expect(result).to eql 4 }
    it { expect(errors).to be_empty }
  end

  context 'when script fails' do
    let(:script) { 'someObject.doesNotExist()' }
    it { is_expected.to_not be_successful }
    it { expect(errors.size).to eql 1 }
    it { expect(error.message).to eql "someObject is not defined" }
    it { expect(result).to be_nil }
  end

  context 'when script throws' do
    let(:script) { 'throw "Something went wrong"' }
    it { is_expected.to_not be_successful }
    it { expect(errors.size).to eql 1 }
    it { expect(error).to be_a WebPipes::JavascriptExecutor::Error }
    it { expect(error.message).to eql "Something went wrong" }
    it { expect(result).to be_nil }
  end

  context 'when a longer script throws' do
    let(:script) do
      %Q{var a = 1;\n} +
      %Q{var b = a+1;\n} +
      %Q{var c = b+1;\n} +
      %Q{throw "Something went wrong";}
    end
    it { expect(error.message).to eql "Something went wrong" }
    it { expect(error.location.line).to eql 4 }
  end

  context 'when a ruby object inside a scpript throws' do

    CustomError = Class.new(StandardError)

    class RubyKlazz
      def this_fails
        raise CustomError.new("Ruby error")
      end
    end

    before { executor.register(:ruby_object, RubyKlazz.new) }

    let(:script) do
      %Q{var a = 1;\n} +
      %Q{var b = a+1;\n} +
      %Q{ruby_object.this_fails;\n} +
      %Q{var c = b+1;\n}
    end

    it { expect(error.message).to eql "Ruby error" }
    it { expect(error).to be_a WebPipes::JavascriptExecutor::Error }
    it { expect(error.cause).to be_a CustomError }
  end

  context 'when using an external API' do
    class ExternalApi < SimpleApi
      request :get_items do
        Faraday.new(:url => 'http://www.external-api.com').get('/items')
      end
    end

    let(:script) { 'externalApi.getItems' }

    before do
      executor.register(:externalApi, ExternalApi.new)
      stub_request(:get, "http://www.external-api.com/items").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.0'}).
        to_return(:status => status_code, :body => response_body, :headers => {})
    end

    context 'and the request succeeds' do
      let(:status_code) { 200 }
      let(:response_body) { JSON.dump(["Hello", " ", "World"])}

      it { is_expected.to be_successful }
      it { expect(result).to eql ["Hello", " ", "World"] }
    end

    context 'and the request fails' do
      let(:status_code) { 404 }
      let(:response_body) { "" }

      it { is_expected.to_not be_successful }
      it { expect(errors.size).to eql 1 }
      it { expect(error.message).to eql "getItems returned a 404 status" }
    end
  end

end
