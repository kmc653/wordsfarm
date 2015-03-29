require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:vocabularies) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end
end