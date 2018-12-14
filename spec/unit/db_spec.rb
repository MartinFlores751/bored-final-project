require File.expand_path '../../spec_helper.rb', __FILE__


describe User do
  it { should have_property :id }
  it { should have_property :email }
  it { should have_property :password }
  it { should have_property :created_at }
  it { should have_property :role }
end


describe Sheet do
  it { should have_property :id }
  it { should have_property :email }
  it { should have_property :title }
  it { should have_property :description }
  it { should have_property :created_at }
  it { should have_property :file_path }
end
