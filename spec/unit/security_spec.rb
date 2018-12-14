require File.expand_path '../../spec_helper.rb', __FILE__


describe 'When Customer, Music Sheet' do

  before(:all) do
    @u = User.new
    @u.email = "user@user.com"
    @u.password = "user"
    @u.role = 1
    @u.save

    visit "/"
    page.set_rack_session(user_id: @u.id)

    s = Sheet.new
    s.email = "bob@bob.com"
    s.title = "wow!"
    s.description = "om nom nom"
    s.file_path = "nope"

    s = Sheet.new
    s.email = "pop@pop.com"
    s.title = "mom!"
    s.description = "ow now now"
    s.file_path = "nobe"

    s = Sheet.new
    s.email = "cool@thing.com"
    s.title = "Yeeesh!"
    s.description = "Thing thang bing bang!"
    s.file_path = "AAAAH"
  end


  it 'should not allow requests to /sell' do
    visit '/sell'
    expect(page).to have_current_path("/")
  end


  it 'should not allow GET requests to /upload_music' do
    visit '/upload_music'
    exepct(page).to have_current_path("/")
  end


  it 'should not allow POST requests to /upload_music' do
    page.driver.browser.post('/sell')

    expect(page).to have_current_path("/")
  end

end


describe 'When Seller, Music Sheet' do

  before(:all) do
    @u = User.new
    @u.email = "seller@sell.com"
    @u.password = "money"
    @u.role = 2
    @u.save

    page.set_rack_session(user_id: @u.id)

    s = Sheet.new
    s.email = "seller@sell.com"
    s.title = "Fak"
    s.description = "'Tis music V1"
    s.file_path = "NULL"
    s.save

    s = Sheet.new
    s.email = "seller@sell.com"
    s.title = "Fak - MVMT 2"
    s.description = "'Tis music V2"
    s.file_path = "NULL"
    s.save

    s = Sheet.new
    s.email = "seller@sell.com"
    s.title = "Fak - A tribute to contribute"
    s.description = "'Tis music V3"
    s.file_path = "NULL"
    s.save

    s = Sheet.new
    s.email = "notseller@sell.com"
    s.title = "Fake"
    s.description = "not real"
    s.file_path = "NULL"
    s.save
  end


  it 'should allow seller to view their uploaded music on /sell' do
    visit '/sell'
    s = Sheet.all(email: "seller@sell.com")
    s.each do |s|
      expect(page.body).to include(s.title)
    end
  end

end
