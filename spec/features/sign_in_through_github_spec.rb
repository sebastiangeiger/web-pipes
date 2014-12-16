require 'rails_helper'

feature "Sign In Through Github" do

  scenario "when I supply the right credentials" do
    visit "/"
    click_on "Sign in with GitHub"
  end

end
