# ///////////////////////////
# Requires | Gems, DBs, Funcs
# ///////////////////////////
require "sinatra"
require "sinatra/flash"

require_relative "sheet.rb"
require_relative "history.rb"

require_relative "authentication.rb"
require_relative "simple_tokenizer.rb"


# ////////////////////////
# IGNORE | Database Config
# ////////////////////////
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

DataMapper.finalize
User.auto_upgrade!
Sheet.auto_upgrade!
History.auto_upgrade!


# ///////////////////////////////
# IGNORE | Default Database Users
# ///////////////////////////////
if User.all(role: 3).count == 0
  u = User.new
  u.email = "admin@admin.com"
  u.password = "admin"
  u.role = 3
  u.save
end

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
  u.role = 1
  u.save
end


# //////////////////////////
# Request Handlers | General
# //////////////////////////
get "/" do
  #test function for simple_tokenizer.rb uncomment to see the console print
  #test_func
  if current_user
    if current_user.role == 1
      redirect '/dashboard'
    elsif current_user.role == 2
      redirect '/seller_dashboard'
    end
  end
  erb :index
end


# ///////////////////////
# Request Handlers | User
# ///////////////////////
get "/dashboard" do
  @h = History.all(buyer: current_user.id)
  erb :dashboard
end

get "/search" do
  @s = Sheet.all
  erb :finder
end

get "/find_accountzoom" do
  erb :zoom_tmp
end

get "/purchase" do
  erb :purchase
end


# /////////////////////////
# Request Handlers | Seller
# /////////////////////////
get "/seller_dashboard" do
  if current_user.role == 1
    redirect "/"
  else
    @s = Sheet.all(email: current_user.email)
    erb :sell
  end
end

get "/upload_music" do
  if current_user.role == 1
    redirect "/"
  elsif current_user.role == 2
    erb :upload_music
  end
end

post "/upload_music" do
  if current_user && current_user.role == 2
    email = current_user.email
    title = params[:title]
    description = params[:description]
    file = params[:file]

    if title && description && file
      s = Sheet.new

      s.email = email
      s.title = title
      s.description = description
      s.file_path = file

      s.save
    end
  end
end


# /////////////////////////////
# Left Overs (AKA WTF is this?)
# /////////////////////////////
get "/storeroom" do
  return "?"
end

get "/manage" do
  return "?"
end

get "/sell_history" do

end
