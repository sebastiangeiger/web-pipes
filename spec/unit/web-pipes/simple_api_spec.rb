require 'spec_helper'
require 'ostruct'
require 'json'

require_relative '../../../lib/web-pipes/simple_api'

describe SimpleApi do
  subject(:wrapper) { ExampleApi.new }

  class ExampleApi < SimpleApi
    request :get_some_endpoint do
      OpenStruct.new(body: JSON.dump(['Response Body']), success?: true)
    end
    request :get_failing_endpoint do
      OpenStruct.new(body: '', success?: false, status: 403)
    end
  end

  it { is_expected.to respond_to :getSomeEndpoint }
  it { is_expected.to_not respond_to :get_some_endpoint }
  it { expect(wrapper.getSomeEndpoint).to eql ['Response Body'] }

  it { is_expected.to respond_to :getFailingEndpoint }
  it { expect { wrapper.getFailingEndpoint }.to raise_error RequestFailedError }
end
