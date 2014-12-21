require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Jobs' do
  include SignInHelpers

  scenario 'add a job' do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: 'Job #1'
    click_on 'Create Job'
    visit '/'
    expect(page).to have_content 'Job #1'
  end
end
