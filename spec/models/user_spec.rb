require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:vocabularies) }

  it "generates a random token when the user is created" do
    kevin = Fabricate(:user)
    expect(kevin.token).to be_present
  end
end