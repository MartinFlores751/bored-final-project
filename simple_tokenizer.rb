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
			#uncomment puts to see all the numbers the function is successfully parsing
			#puts x
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
def add_item(sheetID, u = current_user)
	if u.nil?
		return "user nonexistant"
	end

	if u.library.empty?
		u.library += sheetID.to_s
		u.save
		return "save successful"
	else
		checkLibrary = grab_items(u.library)
		isPresent = false
		checkLibrary.each do |x|
			isPresent = true if x.to_i == sheetID
		end
		return "number is present already" if isPresent == true
		u.library += "," + sheetID.to_s
		u.save
		return "save successful"
	end
end

#just a quick test function that calls some actions and puts to console
#don't need to use
#just keeping it here for now in case something gets buggy
def test_func
	puts("add_item test")
	add_item(1)
	add_item(2)
	add_item(3)
	u = current_user
	testLibArray = grab_items(u.library)
	puts("size of grab_items array is:")
	puts(testLibArray.length)
	testLibArray.each do |x|
		puts(Sheet.first(:id => x.to_i).title.to_s)
	end
end

def set_up
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
		  s.file_path = "default1.png"
		  s.save
		end

		if Sheet.all(title: "default title 2").count == 0
		  s = Sheet.new
		  s.email = "default@license.com"
		  s.title = "default title 2"
		  s.description = "default description 2"
		  s.file_path = "default2.png"
		  s.save
		end

		if Sheet.all(title: "default title 3").count == 0
		  s = Sheet.new
		  s.email = "default@license.com"
		  s.title = "default title 3"
		  s.description = "default description 3"
		  s.file_path = "default3.jpg"
		  s.save
		end

		if Sheet.all(title: "default title 4").count == 0
		  s = Sheet.new
		  s.email = "default@license.com"
		  s.title = "default title 4"
		  s.description = "default description 4"
		  s.file_path = "default4.png"
		  s.save
		end

		if Sheet.all(title: "default title 5").count == 0
		  s = Sheet.new
		  s.email = "default@license.com"
		  s.title = "default title 5"
		  s.description = "default description 5"
		  s.file_path = "default5.png"
		  s.save
		end

		if User.all(email: "default@customer.com").count == 0
		  u = User.new
		  u.email = "default@customer.com"
		  u.password = "default"
		  u.role = 1
		  u.save
		end
		u = User.first(:email => "default@customer.com")
		add_item(Sheet.first(:title => "default title").id.to_i, u)
		add_item(Sheet.first(:title => "default title 2").id.to_i, u)
		add_item(Sheet.first(:title => "default title 3").id.to_i, u)
end



