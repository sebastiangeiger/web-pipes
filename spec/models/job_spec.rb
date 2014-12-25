require 'rails_helper'

RSpec.describe Job, type: :model do
  describe '#code_versions' do
    let(:code_version) { CodeVersion.new }
    let(:job) { Job.create(name: 'some name') }
    subject { job.code_versions }

    it { is_expected.to match_array [] }

    context 'when assiging a job' do
      before { job.code_versions << code_version }
      it { is_expected.to match_array [code_version] }
    end
  end
end
