require 'rails_helper.rb'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end