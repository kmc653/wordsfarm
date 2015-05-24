require 'spec_helper'

describe QueueItemsController do
  describe "POST create" do
    it_behaves_like "require login" do
      let(:action) { post :create, vocabulary_id: 3 }
    end

    it "redirect to the user page" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      post :create, user_id: kevin.id, vocabulary_id: word.id
      expect(response).to redirect_to sort_by_created_date_path(ellie)
    end

    it "create a queue item" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      post :create, user_id: kevin.id, vocabulary_id: word.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the vocabulary" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      post :create, user_id: kevin.id, vocabulary_id: word.id
      expect(QueueItem.first.vocabulary).to eq(word)
    end

    it "creates the item that is associated with the current user" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      post :create, user_id: kevin.id, vocabulary_id: word.id
      expect(QueueItem.first.user).to eq(kevin)
    end

    it "does not add word to the queue if the word is already in the queue" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      Fabricate(:queue_item, user: kevin, vocabulary: word)
      post :create, user_id: kevin.id, vocabulary_id: word.id
      expect(kevin.queue_items.count).to eq(1)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require login" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the user page" do
      kevin = Fabricate(:user)
      set_current_user(kevin)
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sort_by_created_date_path(kevin)
    end

    it "delete the item" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      queue_item = Fabricate(:queue_item, user: kevin, vocabulary: word)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not delete the item if the item is not in the current user's queue" do
      kevin = Fabricate(:user)
      ellie = Fabricate(:user)
      set_current_user(kevin)
      word = Fabricate(:vocabulary, creator: ellie)
      queue_item = Fabricate(:queue_item, user: ellie)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
  end
end