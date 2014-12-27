require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { Job.create(name: 'some name') }

  describe '#code_versions' do
    let(:code_version) { CodeVersion.new }
    subject { job.code_versions }

    it { is_expected.to match_array [] }

    context 'when assiging a job' do
      before { job.code_versions << code_version }
      it { is_expected.to match_array [code_version] }
    end
  end

  describe '#code' do
    subject { job.code }
    context 'without a code_version' do
      it { is_expected.to eql '' }
    end
    context 'after assigning a code_version' do
      before { CodeVersion.create(job: job, code: 'code #1') }
      it { is_expected.to eql 'code #1' }
    end
    context 'after assigning two code_versions' do
      before do
        CodeVersion.create(job: job, code: 'code #1')
        CodeVersion.create(job: job, code: 'code #2')
      end
      it { is_expected.to eql 'code #2' }
    end
  end
end
