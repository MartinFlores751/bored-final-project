require "sinatra"
require_relative "authentication.rb"
require_relative "sheet.rb"
require_relative "history.rb"
require "sinatra/flash"


if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

DataMapper.finalize
User.auto_upgrade!
Sheet.auto_upgrade!
History.auto_upgrade!


if User.all(role: 3).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.role = 3
  u.save
end

#Default users and default sheet for testing purposes
if User.all(email: "default@license.com").count == 0
  u = User.new
  u.email = "default@license.com"
  u.password = "default"
  u.role = 2
  u.save
end

if Sheet.all(title: "default title").count == 0
  s = Sheet.new
  s.email = "default@license.com"
  s.title = "default title"
  s.description = "default description"
  s.file_path = "default path"
  s.save
end

if User.all(email: "default@customer.com").count == 0
  u = User.new
  u.email = "default@customer.com"
  u.password = "default"
  u.role = 2
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
  s = Sheet.all
	return s.to_json
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


post "/upload_music" do
  if current_user && current_user.role == 1
  redirect "/"
  elsif current_user.role == 2
  email = current_user.email
  title = params["title"]
  description = params["description"]
  file = params["file"]
  if email && title && description && file
    s = Sheet.new
    s.email = email
    s.title = title
    s.description = description
   	s.file_path = file
    s.save
  end
end
end

get "/sell_history" do

end
get "/seller_dashboard" do

end
