require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Code' do
  include SignInHelpers

  background do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: 'Job #1'
    click_on 'Next'
  end

  scenario 'add correct code to a job' do
    fill_in :job_code, with: 'console.log("1+2=" + (1+2));'
    click_on 'Save & Test'
    expect(page).to have_content 'console.log("1+2=" + (1+2));'
    expect(page).to have_content '1+2=3'
  end

  scenario 'add failing code to a job' do
    fill_in :job_code, with: 'console.error("1+2=" + (1+2));'
    click_on 'Save & Test'
    expect(page).to have_content 'console.error("1+2=" + (1+2));'
    expect(page).to have_content "Object [object Object] has no method 'error'"
  end

  scenario 'add code with syntax error to a job' do
    fill_in :job_code, with: 'function(]{};'
    click_on 'Save & Test'
    expect(page).to have_content 'function(]{};'
    expect(page).to have_content 'Unexpected token ( at <eval>:1:10'
  end
end
