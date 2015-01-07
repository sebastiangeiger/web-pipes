require 'rails_helper'
require 'support/sign_in_helpers'

feature 'Periodically running a job' do
  include SignInHelpers

  background do
    fake_sign_in!
    visit '/'
    click_on 'New Job'
    fill_in :job_name, with: 'Job #1'
    click_on 'Next'
    fill_in :job_code, with: 'console.log("1+2=" + (1+2));'
    click_on 'Save & Test'
  end

  scenario 'running jobs' do
    visit '/'
    click_on 'Job #1'
    expect(page.all('#execution-results .result').size).to eql 0
    PeriodicJob.perform_later(Job.first)
    visit '/'
    click_on 'Job #1'
    expect(page.all('#execution-results .result').size).to eql 1
  end
end
