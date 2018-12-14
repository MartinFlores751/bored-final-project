require "sinatra"
require_relative "authentication.rb"
require_relative "sheet.rb"
require "sinatra/flash"

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil


# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

DataMapper.finalize
User.auto_upgrade!
Sheet.auto_upgrade!

if User.all(role: 3).count == 0
	u = User.new
	u.email = "admin@admin.com"
	u.password = "admin"
	u.role = 3
	u.save
end

# Landing page
get "/" do
	erb :index
end

# User Dashboard
get "/dashboard" do
	erb :dashboard
end

# Seller Dashboard
get "/sell" do
	if current_user.role == 1
  redirect "/"
else
	s = Sheet.all(email: "seller@sell.com")
	return s.to_json
	#erb :sell
end
end

# Search for sellers in seller DB
get "/search" do
  erb :finder
end

# ???
get "/storeroom" do
  return "?"
end

# Placeholder
get "/find_accountzoom" do
  erb :zoom_tmp
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
 if current_user.role == 1
  redirect "/"
elsif current_user.role == 2
 erb :upload_music
end
end

get "/seller_dashboard" do
  return "?"
end
post "/upload_music" do
  #email = params["email"]
  if current_user && current_user.role == 1
  redirect "/"
  elsif current_user.role == 2
  title = params["title"]
  description = params["description"]
  file = params["file"]
  #created_at = params["created_at"]
  #file_path = params["file_path"]
  if title && description && file
    s = Sheet.new
  #  s.email = email
    s.title = title
    s.description = description
   s.file_path = file
   # s.created_at = created_at
    #s.file_path = file_path
    s.save
  end
end
end

get "/sell_history" do 

end