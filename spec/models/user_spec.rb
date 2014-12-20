require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:full_name) { 'Jon Doe' }
    let(:username) { 'jondoe' }
    let(:provider_uid) { 'github_0815' }
    subject(:user) do
      User.new(full_name: full_name,
               username: username,
               provider_uid: provider_uid)
    end

    it { is_expected.to be_valid }

    context 'when username is nil' do
      let(:username) { nil }
      it { is_expected.to_not be_valid }
    end

    context 'when provider_uid is nil' do
      let(:provider_uid) { nil }
      it { is_expected.to_not be_valid }
    end

    context 'when another user with the same provider_uid exists' do
      before do
        User.create!(provider_uid: provider_uid,
                     full_name: 'Some User',
                     username: 'someuser')
      end
      it { is_expected.to_not be_valid }
    end

    context 'when full_name is nil' do
      let(:full_name) { nil }
      it { is_expected.to_not be_valid }
    end
  end
end
