require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Jobs' do
  include SignInHelpers

  scenario 'add a job' do
    fake_sign_in!
    visit '/'
    click_on "New Job"
  end
end

