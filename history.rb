require 'data_mapper' # metagem, requires common plugins too.

class History
    include DataMapper::Resource
    property :id, Serial
    property :sheet_id, Integer #when you create a history object, query for the Serial id of the sheet and put it here
    property :created_at, DateTime  #time of transaction
    property :charge, String #money made from transaction
    property :buyer, Integer
    property :seller, Integer
end
