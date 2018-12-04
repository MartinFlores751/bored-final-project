require "sinatra"
require_relative "authentication.rb"
require "sinatra/flash"

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

if User.all(role: 3).count == 0
	u = User.new
	u.email = "admin@admin.com"
	u.password = "admin"
	u.role = 3
	u.save
end

# Langind page
get "/" do
	erb :index
end

# User Dashboard
get "/user" do
	erb :dashboard
end

# Seller Dashboard
get "/sell" do
	erb :sell
end

# ???
get "/finder" do
  return "?"
end

# ???
get "/storeroom" do
  return "?"
end

# Placeholder
get "/find_accountzoom" do
  return "TEMP TEMP TEMP"
end

# Buy the current item
get "/purchase" do
	erb :purchase
end

# ???
get "/manage" do
  return "?"
end

# Only to seller
get "/upload_music" do
 erb :upload_music
end
