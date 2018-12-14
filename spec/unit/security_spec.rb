require File.expand_path '../../spec_helper.rb', __FILE__


describe 'When Customer, Music Sheet' do

  before(:all) do
    @u = User.new
    @u.email = "user@user.com"
    @u.password = "user"
    @u.role = 1
    @u.save

    page.set_rack_session(user_id: @u.id)

    s = Sheet.new
    s.email = "bob@bob.com"
    s.title = "wow!"
    s.description = "om nom nom"
    s.file_path = "nope"
    s.save

    s = Sheet.new
    s.email = "pop@pop.com"
    s.title = "mom!"
    s.description = "ow now now"
    s.file_path = "nobe"
    s.save

    s = Sheet.new
    s.email = "cool@thing.com"
    s.title = "Yeeesh!"
    s.description = "Thing thang bing bang!"
    s.file_path = "AAAAH"
    s.save
  end


  it 'should not allow requests to /seller_dashboard' do
    visit '/seller_dashboard'
    expect(page).to have_current_path("/")
  end


  it 'should not allow requests to /upload_music' do
    visit '/upload_music'
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


  it 'should allow seller to view their uploaded music on /seller_dashboard' do
    visit '/seller_dashboard'
    s = Sheet.all(email: @u.email)
    s.each do |s|
      expect(page.body).to include(s.title)
    end
  end

end
