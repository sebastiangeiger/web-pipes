require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Code' do
  include SignInHelpers

  scenario 'add code to a job' do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: 'Job #1'
    click_on 'Next'
    fill_in :job_code, with: 'console.log("Hello World");'
    click_on 'Save & Test'
    expect(page).to have_content 'console.log("Hello World");'
  end
end
