require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  before do
    DB[:users].delete
  end

  scenario 'Login, logout, register' do
    visit '/'

    expect(page).to have_content 'Welcome!'
    click_on 'Register'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password_confirmation', :with => 'password'
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
    fill_in 'Password', :with => 'anything'
    click_on 'Login'
    expect(page).to have_content 'You have not entered a valid email or password'
    fill_in 'Email', :with => ''
    click_on 'Login'
    expect(page).to have_content 'You have not entered a valid email or password'
    fill_in 'Email', :with => ''
    fill_in 'Password', :with => ''
    click_on 'Login'
    expect(page).to have_content 'You have not entered a valid email or password'
    expect(page).to have_no_content 'Welcome Admin'
  end
  scenario 'User attempts to register an email that is already in the system' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password_confirmation', :with => 'password'
    click_on 'Register'
    click_on 'Logout'
    click_on 'Register'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => 'whatever'
    fill_in 'Password_confirmation', :with => 'whatever'
    click_on 'Register'
    expect(page).to have_content 'Email already exists'
  end
  scenario 'User cannot Register an empty email' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => '       '
    fill_in 'Password', :with => 'password'
    fill_in 'Password', :with => 'password'
    click_on 'Register'
    expect(page).to have_content 'Email cannot be blank'
  end
  scenario 'User cannot register a password less than 3 chars' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => 'joe@example.com'
    fill_in 'Password', :with => '12'
    fill_in 'Password', :with => '12'
    click_on 'Register'
    expect(page).to have_content 'Password cannot be less than 3 chars'
  end
  scenario 'Email must be a valid email address' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => 'joe.com'
    fill_in 'Password', :with => '134452'
    fill_in 'Password', :with => '134452'
    click_on 'Register'
    expect(page).to have_content 'Email Address must be valid'
  end
  scenario 'Password must match Password confirmation' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => 'fred@example.com'
    fill_in 'Password', :with => '134452'
    fill_in 'Password_confirmation', :with => 'wrongpasswrod'
    click_on 'Register'
    expect(page).to have_content 'Password must match password confirmation'
  end
  scenario 'Password cannot be blank' do
    visit '/'
    click_on 'Register'
    fill_in 'Email', :with => 'fred@example.com'
    fill_in 'Password', :with => '    '
    fill_in 'Password_confirmation', :with => '    '
    click_on 'Register'
    expect(page).to have_content 'Password must not be blank'
  end
  scenario 'Admin can view all users but regular users cannot' do
    DB[:users].insert(email: 'cheers@cheers.com', password: BCrypt::Password.create('whatever'), admin: true)
    DB[:users].insert(email: 'google.com', password: "password", admin: false)
    DB[:users].insert(email: 'foogle.com', password: "password", admin: false)
    visit '/'
    click_on 'Login'
    fill_in 'Email', :with => 'cheers@cheers.com'
    fill_in 'Password', :with => 'whatever'
    click_on 'Login'
    expect(page).to have_content 'Welcome Admin'
    click_on 'Users'
    expect(page).to have_content 'google.com'
    expect(page).to have_content 'foogle.com'

  end
  scenario 'Non admin cannot see user page' do
    DB[:users].insert(email: 'foogle.com', password: BCrypt::Password.create('password'), admin: false)
    visit '/'
    click_on 'Login'
    fill_in 'Email', :with => 'foogle.com'
    fill_in 'Password', :with => 'password'
    click_on 'Login'
    visit '/users'
    expect(page).to have_content 'Not Authorized'
  end
end