require 'data_mapper' # metagem, requires common plugins too.

class Sheet
    include DataMapper::Resource
    property :id, Serial
    property :email, String #to avoid conflicts with sheet music that has the same name we use
                            #user email to fetch all music to a licensholder
    property :title, String
    property :description, String
    property :created_at, DateTime
    property :file_path, String
end
