require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Jobs' do
  include SignInHelpers

  scenario 'add a valid job' do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: 'Job #1'
    click_on 'Next'
  end

  scenario 'add a job without a name' do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: ''
    click_on 'Next'
    expect(page).to have_content "Name can't be blank"
  end
end
