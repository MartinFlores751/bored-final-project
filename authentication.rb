require 'sinatra'
require_relative "user.rb"

enable :sessions

set :session_secret, 'super secret'

get "/login" do
	erb :"authentication/login"
end


post "/process_login" do
	email = params[:email]
	password = params[:password]

	user = User.first(email: email.downcase)

	if(user && user.login(password))
		session[:user_id] = user.id
		redirect "/"
	else
		erb :"authentication/invalid_login"
	end
end

get "/logout" do
	session[:user_id] = nil
	redirect "/"
end

get "/sign_up" do
	erb :"authentication/sign_up"
end


post "/register" do
	email = params[:email]
	password = params[:password]

	u = User.new
	u.email = email.downcase
	u.password = password
	if !(params[:isLH].nil?)
		u.role = 2
	else
		u.role = 1
	end
	u.save

	session[:user_id] = u.id

	erb :"authentication/successful_signup"

end

#This method will return the user object of the currently signed in user
#Returns nil if not signed in
def current_user
	if(session[:user_id])
		@u ||= User.first(id: session[:user_id])
		return @u
	else
		return nil
	end
end


# TODO: Make this return True when on the market
def display_search!
  return nil
end


#if the user is not signed in, will redirect to login page
def authenticate!
	if !current_user
		redirect "/login"
	end
end

def authenticateSubbed!
	if current_user.subbed == false
		if current_user.role == 3
			#do nothing we're good
		else
			redirect "/get_subbed"
		end
	end
end

def authenticate_customer!
	if !current_user
		redirect "/login"
	elsif (current_user.role != 1 || current_user.role != 3)
		redirect "/"
	end
end

def authenticate_lincenser!
	if !current_user
		redirect "/login"
	
	elsif (current_user.role != 2 || current_user.role != 3)
		redirect "/"
	end
end
