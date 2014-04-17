require 'sinatra/base'


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
    error = nil
    user_id = session[:id]
    if user_id.nil?
      erb :index, :locals => {:logged_in => false, :error => error}
    else
      email = user_table[:id => user_id][:email]
      erb :index, :locals => {:logged_in => true, :email => email, :error => error}
    end
  end

  get '/register' do
    erb :register
  end

  get '/login' do
    erb :login, locals: {need_error: false}
  end

  post '/' do
    id = user_table.insert(:email => params[:Email], :password => params[:Password])
    session[:id] = id
    redirect '/'
  end

  post '/login' do
    does_email_exist =  user_table[:email => params[:Email]]
    does_password_match = user_table[:password => params[:Password]]
    if does_email_exist && does_password_match
      error = nil
      erb :index, :locals => {:logged_in => true, :error => error, :email => params[:Email]}
    elsif does_email_exist == ''
      error = "You have not entered a valid email or password"
      erb :login, :locals => {:need_error => true, error: error}
    else
      error = "You have not entered a valid email or password"
      erb :login, :locals => {:need_error => true, error: error}
    end
  end

  get '/logout' do
    error = nil
    erb :index, :locals => {:logged_in => false, :error => error}
  end

end

