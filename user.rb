require 'data_mapper' # metagem, requires common plugins too.

class User
    include DataMapper::Resource
    property :id, Serial
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :role, Integer #Integer account roles: 1 for standard user, 2 for license holders, 3 for admin
    property :library, String, :default => ""  # user starts with default library no need to initialize it ever 

    def login(password)
    	return self.password == password
    end
end
