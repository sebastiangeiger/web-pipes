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

  describe '#update' do
    subject(:update) { job.update({code: code}) }

    context 'when the job does not have a code version yet' do
      let(:code) { 'function(){};' }
      it 'creates a job version' do
        expect { update }.to change(CodeVersion, :count).from(0).to(1)
      end
      it 'is accessible through #code' do
        expect { update }.to change(job, :code).from('').to(code)
      end
    end

    context 'when the job already has a code version' do
      before { CodeVersion.create(job: job, code: 'function(){};') }

      context 'when trying to save new code' do
        let(:code) { 'function(args){};' }
        it 'creates a code version' do
          expect { update }.to change(CodeVersion, :count).from(1).to(2)
        end
      end

      context 'when trying to save the same code' do
        let(:code) { 'function(){};' }
        it 'does not create a code version' do
          expect { update }.to_not change(CodeVersion, :count).from(1)
        end
      end
    end
  end
end
