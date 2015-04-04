require 'spec_helper'

describe CategoriesController do
  describe "POST create" do
    context "with authenticated user" do
      context "with valid input" do

        it "creates the category" do
          kevin = Fabricate(:user)
          set_current_user(kevin)
          post :create, category: Fabricate.attributes_for(:category), user_id: kevin.id
          expect(Category.count).to eq(1)
        end

        it "redirects to the user's category show page" do
          kevin = Fabricate(:user)
          set_current_user(kevin)
          post :create, category: Fabricate.attributes_for(:category), user_id: kevin.id
          expect(response).to redirect_to category_path(kevin)
        end
      end
      context "with invalid input" do

      end
    end
      
  end
end