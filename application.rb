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
    if session[:user_id]
      id = session[:user_id]
      email = user_table[:id => id][:email]
      erb :index, :locals => {:email => email}
    else
      erb :index
    end
  end

  get '/register' do
    erb :register
  end

  post '/' do
    id = user_table.insert(:email => params[:Email], :password => params[:Password])
    session[:user_id] = id

    redirect '/'
  end

  #get '/logout' do
  #  session[:user_id]
  #  id = session[:user_id]
  #  email = user_table[:id => id][:email]
  #  erb :index, :locals => {:email => email}
  #end

  get '/logout' do
    session[:user_id] = false
    redirect '/'
  end

end

