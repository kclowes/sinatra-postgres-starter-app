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
    erb :index
  end

  get '/register' do
    erb :register
  end

  get '/login' do
    erb :login
  end

  post '/' do
    user_table.insert(:email => params[:Email])
    user = user_table.filter(:email => params[:Email]).first
    if user
      erb :index, :locals => {:user => user}
    else
      erb :index
    end
  end

  get '/logout' do
    session[:user_id] = false
    redirect '/'
  end

end

