require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: kevin, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require login" do
      let(:action) { get :index}
    end
  end

  describe "POST create" do
    it_behaves_like "require login" do
      let(:action) { post :create}
    end

    it "redirects to the people page" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "create a relationship that current user follows the leader" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      post :create, leader_id: bob.id
      expect(kevin.following_relationships.first.leader).to eq(bob)
    end

    it "does not create a relationship if the current user already follow the leader" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      Fabricate(:relationship, follower: kevin, leader: bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow themselves" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      post :create, leader_id: kevin.id
      expect(Relationship.count).to eq(0)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require login" do
      let(:action) { delete :destroy, id: 3}
    end

    it "redirects to the people page" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      relationship = Fabricate(:relationship, follower: kevin, leader: bob)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "delete the relationship if current user is the follower" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(kevin)
      relationship = Fabricate(:relationship, follower: kevin, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      set_current_user(kevin)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end