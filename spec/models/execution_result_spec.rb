require 'rails_helper'

RSpec.describe ExecutionResult, type: :model do
  let(:job) { Job.create!(name: 'Job #1') }

  describe '#validations' do
    subject { ExecutionResult.new(params) }

    context 'with a job' do
      let(:params) { { job: job } }
      it { is_expected.to be_valid }
    end

    context 'without a job' do
      let(:params) { {} }
      it { is_expected.to_not be_valid }
    end
  end

  describe '#job' do
    let(:execution_result) { ExecutionResult.new(job: job) }

    subject { execution_result.job }

    it { is_expected.to eql job }
  end

  describe '#status' do
    subject { execution_result.status }

    context 'with no status' do
      let(:execution_result) { ExecutionResult.new(job: job) }

      it { is_expected.to be_nil }
    end

    context 'with a status' do
      let(:execution_result) do
        ExecutionResult.new(job: job, status: 'Hello')
      end

      it { is_expected.to eql 'Hello' }
    end
  end

  describe '#messages' do
    subject { execution_result.messages }

    context 'with no messages' do
      let(:execution_result) { ExecutionResult.new(job: job) }

      it { is_expected.to eql [] }
    end

    context 'with a messages' do
      let(:execution_result) do
        ExecutionResult.new(job: job, messages: ['Hello'])
      end

      it { is_expected.to eql ['Hello'] }
    end
  end
end
