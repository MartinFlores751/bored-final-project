require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/sheet.db")
end

class Sheet
    include DataMapper::Resource
    property :id, Serial
    property :email, String #to avoid conflicts with sheet music that has the same name we use
                            #user email to fetch all music to a licensholder
    property :title, String
    property :description, String
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Sheet.auto_upgrade!
