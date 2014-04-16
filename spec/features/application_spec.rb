require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  before do
    DB[:users].delete
  end

  scenario 'Shows the welcome message' do
    visit '/'

    expect(page).to have_content 'Welcome!'
    click_on 'Register'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'password'
    click_on 'Register'
    expect(page).to have_content 'Hello, joe@example.com'
    click_on 'Logout'
    expect(page).to have_content 'Welcome!'
    click_on 'Login'
  end
end