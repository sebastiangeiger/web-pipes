require 'rails_helper'

RSpec.describe CodeVersion, type: :model do
  describe '#job' do
    let(:code_version) { CodeVersion.new }
    let(:job) { Job.new }

    it { is_expected.to_not be_valid }

    context 'when assiging a job' do
      before { code_version.job = job }
      it 'returns the assigned job' do
        expect(code_version.job).to eql job
      end
    end
  end
end
