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
    visit page.current_path
    expect(page).to have_content 'Hello, joe@example.com'
    click_on 'Logout'
    expect(page).to have_content 'Welcome!'
    click_on 'Login'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'password'
    click_on 'Login'
    expect(page).to have_content 'Hello, joe@example.com'
    click_on 'Logout'
    click_on 'Login'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'something'
    click_on 'Login'
    expect(page).to have_content 'You have not entered a valid email or password'
    fill_in 'Email', :with => 'hilary'
    click_on 'Login'
    expect(page).to have_content 'You have not entered a valid email or password'
    fill_in 'Email', :with => ''
    expect(page).to have_content 'You have not entered a valid email or password'

  end
end