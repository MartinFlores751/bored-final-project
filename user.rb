require 'data_mapper' # metagem, requires common plugins too.

class User
    include DataMapper::Resource
    property :id, Serial
    property :email, String
    property :password, String
    property :created_at, DateTime
    property :role, Integer #Integer account roles: 1 for standard user, 2 for license holders, 3 for admin
    property :library, String, :default => ""  # user starts with default library no need to initialize it ever
    property :subbed, Boolean, :default => false # this is irrelavant for standard users.  A licenser needs to be subbed to use our platform

    def login(password)
    	return self.password == password
    end
end
