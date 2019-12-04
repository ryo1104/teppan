require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user_create)       { FactoryBot.create(:user) }
  let(:topic_create)      { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)       { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  let(:review_attributes) { FactoryBot.attributes_for(:review)}
  render_views

  describe "POST #create" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        @review_attributes = review_attributes
      end
      it "populates @neta" do
        post :create, params: { neta_id: @neta.id, review: @review_attributes }
        expect(assigns(:neta)).to match(@neta)
      end
      it "creates a review" do
        expect{
          post :create, params: { neta_id: @neta.id, review: @review_attributes }
        }.to change(Review, :count).by(1)
      end
      it "updates neta's average rate column" do
        @another_user = create(:user)
        @another_review = create(:review, user: @another_user, neta: @neta, rate: 2)
        post :create, params: { neta_id: @neta.id, review: {rate: 5, text: Faker::Lorem.characters(number: 50)} }
        @neta.reload
        expect(@neta.average_rate).to eq 3.5
      end
      it "redirects to neta#show" do
        post :create, params: { neta_id: @neta.id, review: @review_attributes }
        expect(response).to redirect_to neta_path(@neta.id)
      end
      context "when update average rate fails" do
        before do
          allow_any_instance_of(Neta).to receive(:update_average_rate).and_return([false, "some error message"])
        end
        it "writes to Rails logger an error message" do
          expect(Rails.logger).to receive(:error).with("Neta::update_average_rate returned false : some error message")
          post :create, params: { neta_id: @neta.id, review: @review_attributes }
        end
        it "redirects to neta#show" do
          post :create, params: { neta_id: @neta.id, review: @review_attributes }
          expect(response).to redirect_to neta_path(@neta.id)
        end
      end
    end
    context "as a guest" do
      before do
        @neta = neta_create
        @review_attributes = review_attributes
      end
      it "redirects to user sign-in page" do
        post :create, params: { neta_id: @neta.id, review: @review_attributes }
        expect(response).to redirect_to "/users/sign_in"
      end
      it "returns a 302 status code" do
        post :create, params: { neta_id: @neta.id, review: @review_attributes }
        expect(response).to have_http_status("302")
      end
    end
  end
  
  describe "GET #show" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        @review = FactoryBot.create(:review, neta: @neta, user: @user)
        @comments = create_list(:comment, 5, :with_user, commentable: @review)
      end
      it "populates @review" do
        get :show, params: { id: @review.id }
        expect(assigns(:review)).to match(@review)
      end
      it "populates @comments" do
        get :show, params: { id: @review.id }
        expect(assigns(:comments)).to match(@comments)
      end
    end
    context "as a guest" do
      before do
        @user = user_create
        @neta = neta_create
        @review = FactoryBot.create(:review, neta: @neta, user: @user)
        @comments = create_list(:comment, 5, :with_user, commentable: @review)
      end
      it "redirects to user sign-in page" do
        get :show, params: { id: @review.id }
        expect(response).to redirect_to "/users/sign_in"
      end
      it "returns a 302 status code" do
        get :show, params: { id: @review.id }
        expect(response).to have_http_status("302")
      end
    end
  end
end
