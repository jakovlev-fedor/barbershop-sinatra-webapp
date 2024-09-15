# frozen_string_literal: true

require 'sinatra'

configure do
  enable :sessions
end

get '/' do
  erb :invite
end

get '/login/form' do
  erb :login_form
end

get '/logout' do
  session.delete(:identity)
  erb :logout
end

get '/secret/place' do
  erb :secret_place
end

before '/secret/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = "Sorry, in order to visit '#{request.path}' you must log in"
    @bg_color = 'bg-warning'
    @font_color = 'text-dark'
    halt erb(:login_form)
  end
end

post '/login/attempt' do
  username = params['username']
  password = params['password']
  if username == 'admin' && password == 'admin'
    session[:identity] = params['username']
    where_user_came_from = session[:previous_url] || '/'
    redirect to where_user_came_from
  else
    @error = 'Wrong username or password'
    @bg_color = 'bg-danger'
    @font_color = 'text-white'
    halt erb(:login_form)
  end
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end
