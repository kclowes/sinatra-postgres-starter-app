require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)

    # initialize any other instance variables for you
    # application below this comment. One example would be repositories
    # to store things in a database.

  end

  user_table = DB[:users]

  get '/' do

    id = session[:id]
    user = user_table.where(id: id).first
    erb :index, :locals => {:user => user}
  end

  get '/register' do
    erb :register, locals: {need_error: false}
  end

  get '/login' do
    erb :login, locals: {need_error: false}
  end

  post '/register' do
    password = params[:Password]
    email = params[:Email]
    password_confirmation = params[:Password_confirmation]

    if user_table[email: email]
      error = 'Email already exists'
      erb :register, locals: {need_error: true, :error => error}
    elsif email.strip == ''
      error = 'Email cannot be blank'
      erb :register, locals: {need_error: true, :error => error}
    elsif password.length < 3
      error = 'Password cannot be less than 3 chars'
      erb :register, locals: {need_error: true, :error => error}
    elsif /[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\.[-0-9a-zA-Z.+_]{2,6}/.match(email).nil?
      error = 'Email Address must be valid'
      erb :register, locals: {need_error: true, :error => error}
    elsif password != password_confirmation
      error = 'Password must match password confirmation'
      erb :register, locals: {need_error: true, :error => error}
    elsif password.strip == ''
      error = 'Password must not be blank'
      erb :register, locals: {need_error: true, :error => error}
    else
      id = user_table.insert(:email => email, :password => BCrypt::Password.create(password))
      session[:id] = id
      redirect '/'
    end

  end

  post '/login' do
    email = params[:Email]
    user = user_table.where(:email => email).to_a.first
    password = params[:Password]

    if user.nil? || password.nil?
      error = "You have not entered a valid email or password"
      erb :login, :locals => {:need_error => true, error: error}
    elsif BCrypt::Password.new(user[:password]) == password
      session[:id] = user[:id]
      erb :index, :locals => {:user => user, :error => nil, :email => params[:Email]}
    else
      erb :login, :locals => {:need_error => true, error: "You have not entered a valid email or password"}
    end
  end

  get '/users' do
    id = session[:id]
    user = user_table[:id => id]

    if user[:admin]
      users = user_table.to_a
      erb :users, :locals => {:users => users}
    else
      'Not Authorized'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end

