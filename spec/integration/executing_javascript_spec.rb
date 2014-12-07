require 'rspec'
require_relative '../../lib/web-pipes'

describe 'Executing Javascript' do
  subject(:protocol) { JavascriptExecutor.new.execute(script) }
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

end
