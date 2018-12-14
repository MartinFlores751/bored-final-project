require File.expand_path '../../spec_helper.rb', __FILE__


describe 'Music Sheet' do
  before(:all) do
    @admin = User.new
    @admin.email = "admin@admin.com"
    @admin.password = "admin"
    @admin.role = 3
    @admin.save

    @sell = User.new
    @sell.email = "seller@sell.com"
    @sell.password = "money"
    @sell.role = 2
    @sell.save
    
    @u = User.new
    @u.email = "guy@dude.com"
    @u.password = "totes"
    @u.role = 1
    @u.save

    s = Sheet.new
    s.email = "seller@sell.com"
    s.title = "Fak"
    s.description = "'Tis music"
    s.file_path = "NULL"
    s.save
  end

  
  it 'should allow accessing the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  
  it 'should not be signed in by default' do
    visit '/'
    expect { page.get_rack_session_key('user_id') }.to raise_error(KeyError)
  end

  
  it 'should allow signing up for buyer accounts' do
    visit '/sign_up'
    
    fill_in 'email', with: "test@test.com"
    fill_in 'password', with: "test"

    click_button 'Register'

    u = User.last
    expect(u).not_to be_nil
    expect(u.email).to eq("test@test.com")
    expect(u.password).to eq("test")
    expect(u.role).to eq(1)
  end


  it 'should allow signing up for seller accounts' do
    visit '/sign_up'

    fill_in 'email', with: "a@a.com"
    fill_in 'password', with: "a"
    check 'isLH'

    click_button 'Register'

    u = User.last
    expect(u).not_to be_nil
    expect(u.email).to eq("a@a.com")
    expect(u.password).to eq("a")
    expect(u.role).to eq(2)
  end
  
  
  it 'should allow logging in' do
    visit '/login'

    fill_in 'email', with: "guy@dude.com"
    fill_in 'password', with: "totes"

    click_button 'Login'

    expect(page.get_rack_session_key('user_id')).to eq(@u.id)
  end


  it 'should allow signing out' do
    visit '/'
    
    page.set_rack_session(user_id: @u.id)
    expect(page.get_rack_session_key('user_id')).to eq(@u.id)

    visit '/logout'

    expect { page.get_rack_session_key('user_id') }.to raise_error(KeyError)
  end

  
  it 'should allow requests to /dashboard' do
    page.set_rack_session(user_id: @u.id)

    visit '/dashboard'

    expect(page.status_code).to eq(200)
    expect(page).to have_current_path('/dashboard')
  end

  
  it 'should allow requests to /search' do
    page.set_rack_session(user_id: @admin.id)

    visit '/search'

    expect(page.status_code).to eq(200)
    expect(page).to have_current_path('/search')
  end

  
  it 'should allow POST requests to /upload_music' do
    page.set_rack_session(user_id: @sell.id)
    page.driver.browser.post('/upload_music')

    expect(page.status_code).to eq(200)
    expect(page).to have_current_path("/upload_music")
  end

  
  it 'should allow uploading of music' do
    page.set_rack_session(user_id: @sell.id)
    
    visit '/upload_music'

    fill_in 'title', with: "Mozart PT.2"
    fill_in 'description', with: "This is an old song!"
    fill_in 'file', with: "None"

    click_button 'Submit'

    s = Sheet.last
    expect(s.title).to eq("Mozart PT.2")
    expect(s.description).to eq("This is an old song!")
    # expect(s.file_path).to eq("") Need to find out file path!!!
    expect(s.email).to eq(@admin.email)
  end


  it 'should allow requests to /seller_dashboard' do
    page.set_rack_session(user_id: @sell.id)

    visit '/seller_dashboard'

    expect(page.status_code).to eq(200)
    expect(page).to have_current_path('/seller_dashboard')
  end

  
  
  it 'should allow user to view Sheet Music in /finder' do
    page.set_rack_session(user_id: @u.id)

    sheet = Sheet.all()

    visit '/finder'

    sheet.each do |s|
      expect(page.body).to include(s.title)
    end
  end

  
end
