# ///////////////////////////
# Requires | Gems, DBs, Funcs
# ///////////////////////////
require "sinatra"
require "sinatra/flash"
require "stripe"

require_relative "sheet.rb"
require_relative "history.rb"

require_relative "authentication.rb"
require_relative "simple_tokenizer.rb"


set :publishable_key, 'pk_test_CdF9m4DUiyVaF213fTGOWEZT'
set :secret_key, 'sk_test_Y5GAif7TrBvbDP0Xg2PdBfG6'

Stripe.api_key = settings.secret_key
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
  u.subbed = true
  u.save
end

set_up

# //////////////////////////
# Request Handlers | General
# //////////////////////////
get "/" do
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
  if !(current_user && (current_user.role == 1 || current_user.role == 3))
    redirect '/'
  else
    #HISTORIES ARE FOR SELLERS ONLY
    #@h = History.all(buyer: current_user.id)
    @s = grab_items(current_user.library)
    erb :dashboard
  end
end

get "/search" do
  authenticate!
  @s = Sheet.all
  erb :finder
end

post '/chargeuser' do
  puts(params[:songID])
  # Amount in cents
  if current_user.role ==1
    @amount = 1000
  elsif current_user.role ==2
    @amount = 10000
  end
  customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge',
    :currency    => 'usd',
    :customer    => customer.id
  )
  #add song to list or give them monthly sub
  #
  if current_user.role ==1
    #simply add song to query
    #This is where you create a history object
    #you should only ever create an object HERE
    #params could possibly carry it
    add_item(params[:songID])
    u = History.new
    u.sheet_id = params[:songID].to_i
    u.charge = "$10.00"
    u.buyer = current_user.email
    u.seller = params[:owner]
    u.save
  elsif current_user.role ==2
    #add licenser sub at the end if time permits
    puts("Subscribed wooooooo")
    u = current_user
    u.subbed = true
    u.save
  end
  redirect "/success"
end

get '/success' do
  erb :success
end
# /////////////////////////
# Request Handlers | Seller
# /////////////////////////
get "/seller_dashboard" do
  authenticate!
  authenticateSubbed!
  if current_user && (current_user.role == 2 || current_user.role == 3)
    @s = Sheet.all(email: current_user.email)
    erb :sell
  else
    redirect "/"
  end
end

get "/upload_music" do
  authenticate!
  authenticateSubbed!
  if current_user.role == 1
    redirect "/dashboard"
  elsif current_user.role == 2
    erb :upload_music
  end
end

post "/upload_music" do
  if current_user && current_user.role == 2
    email = current_user.email
    title = params[:title]
    description = params[:description]

    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    if title && description && file
      File.open("./public/img/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
      s = Sheet.new
      s.email = email
      s.title = title
      s.description = description
      s.file_path = @filename

      s.save
    end
  end
  redirect "/"
end

get "/sell_history" do
  authenticate!
  authenticateSubbed!
  @s = History.all(:seller => current_user.email)
  erb :history
end

get "/get_subbed" do
  authenticate!
  erb :purchasecomposer
end

# /////////////////////////////
# Left Overs (Unimplemented items etc.)
# /////////////////////////////
get "/find_accountzoom" do
  authenticate!
  erb :zoom_tmp
end
