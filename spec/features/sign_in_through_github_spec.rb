require 'rails_helper'

feature "Sign In Through Github" do

  scenario "when I supply the right credentials", :external do
    visit "/"
    click_on "Sign in with GitHub"
    expect(current_url).to include "github.com/login"
  end

end
