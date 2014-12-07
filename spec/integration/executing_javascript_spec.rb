require 'rspec'
require 'webmock/rspec'
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
    it { expect(error.message).to eql "Something went wrong" }
    it { expect(result).to be_nil }
  end

  context 'when using an external API' do
    class ExternalApi
      def getItems
        JSON.parse(Faraday.new(:url => 'http://www.external-api.com').get('/items').body)
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
  end

end
