require_relative "authentication.rb"
require_relative "sheet.rb"
require_relative "history.rb"

#this will grab the string provided by the user object that has every 
#id number of the sheet music they are licensed
#expected input:
#user.library = "[id],[id],[id],[id]"
#there should be no spaces of any kind or else behavior is unexpected
#example
#user.library = "10,56,1,155"
#NOTE: NUMBERS DO NOT HAVE TO BE IN ORDER
#will return an array of integers for each song that is licensed to user
#may also return nil if string is empty
def grab_items(lib)
	if lib.empty?
		return nil
	else
		collection = Array.new
		lib.split(',').each do |x|
			puts x
			collection.push(x)
		end
	end
	return collection
end

#expected input:
#user.library = "[id],[id],[id],[id]"
#OR
#user.library = ""
#will append a new number to the string
def add_item(sheetID)
	u = current_user
	if u.nil?
		return "user nonexistant"
	end

	if u.library.empty?
		u.library += sheetID.to_s
		u.save
		return "save successful"
	else
		u.library += "," + sheetID.to_s
		u.save
		return "save successful"
	end
end



