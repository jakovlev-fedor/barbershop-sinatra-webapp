# frozen_string_literal: true

require 'sinatra'
require 'json'

get '/' do
  erb :home
end

get '/about' do
  erb :about
end

# +========================+========================+========================+ #
# =========================|     FORMS HANDLING     |========================= #
# +========================+========================+========================+ #

# ------------------------------ APPOINTMENTS -------------------------------- #
get '/appointment/form' do
  erb :appointment_form
end

post '/appointment/submit' do
  @selected_barber = params[:selected_barber]
  @customer_name = params[:customer_name]
  @customer_phone = params[:customer_phone]
  @appointment_date = params[:appointment_date]
  @appointment_time = params[:appointment_time]

  data = { barber: @selected_barber,
           name: @customer_name,
           phone: @customer_phone,
           date: @appointment_date,
           time: @appointment_time }

  save_data(data, 'customers.jsonl')

  erb :appointment_submit
end

# ------------------------------ MESSAGES ------------------------------------ #
get '/contacts' do
  erb :contacts
end

post '/contacts/message' do
  @email = params[:email]
  @message = params[:message]

  data = { email: @email,
           message: @message }

  save_data(data, 'messages.jsonl')

  erb :message_sent
end

# ------------------------------ LOGIN --------------------------------------- #

configure do
  enable :sessions
end

get '/login/form' do
  erb :login_form
end

get '/logout' do
  session.delete(:identity)
  erb :logout
end

get '/admin' do
  erb :admin
end

before '/admin' do
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
    where_user_came_from = session[:previous_url] || '/admin'
    redirect to where_user_came_from
  else
    @error = 'Wrong username or password'
    @bg_color = 'bg-danger'
    @font_color = 'text-white'
    halt erb(:login_form)
  end
end

# +========================+========================+========================+ #
# =========================|        METHODS         |========================= #
# +========================+========================+========================+ #

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end

  def time_stamp
    t = Time.now
    t.strftime('%Y%m%d-%H%M%S')
  end

  def save_data(data, fname)
    f = File.open(fname, 'a')
    buffer = { time_stamp => data }
    f.write("#{buffer.to_json}\n")
    f.close
  end

  def versioned_stylesheet(style = 'style')
    mtime = File.mtime(File.join(Sinatra::Application.public_dir, 'css', "#{style}.css")).to_i.to_s

    "/css/#{style}.css?" + mtime
  end

  def versioned_javascript(script = 'script')
    mtime = File.mtime(File.join(Sinatra::Application.public_dir, 'js', "#{script}.js")).to_i.to_s

    "/js/#{script}.js?" + mtime
  end
end

# +========================+========================+========================+ #
# =========================|       PLAYGROUND       |========================= #
# +========================+========================+========================+ #

get '/playground' do
  erb :playground
end

# +========================+========================+========================+ #
# =========================|    COLOR PICKER FORM   |========================= #
# +========================+========================+========================+ #

get '/color_picker_form' do
  erb :color_picker_form
end

post '/color_picker_form/submit' do
  erb :color_picker_form_submit
end

# +==============+==============+==============+==============+==============+ #
# ===============|         SERVERSIDE VALIDATION FORM         |=============== #
# +==============+==============+==============+==============+==============+ #

get '/serverside_validation_form' do
  erb :serverside_validation_form
end

post '/serverside_validation_form/submit' do
  @selected_barber = params[:selected_barber]
  @customer_name = params[:customer_name]
  @customer_phone = params[:customer_phone]
  @appointment_date = params[:appointment_date]
  @appointment_time = params[:appointment_time]

  data = { barber: @selected_barber,
           name: @customer_name,
           phone: @customer_phone,
           date: @appointment_date,
           time: @appointment_time }

  save_data(data, 'customers.jsonl')

  erb :appointment_submit
end

# +========================+========================+========================+ #
# =========================|         DEBUG          |========================= #
# +========================+========================+========================+ #

get '/lorem' do
  erb 'Lorem ipsum dolor sit ametzzz'
end

# +========================+========================+========================+ #
# +==============+==============+==============+==============+==============+ #
# +====+====+====+====+====+====+====+====+====+====+====+====+====+====+====+ #
# +==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+==+ #
