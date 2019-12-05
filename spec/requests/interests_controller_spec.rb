require 'rails_helper'

RSpec.describe InterestsController, type: :request do
  let(:user_create)       { FactoryBot.create(:user) }
  let(:topic_create)      { FactoryBot.create(:topic, :with_user) }
  let(:neta_create)       { FactoryBot.create(:neta, :with_user, topic: topic_create) }
  
  describe "POST #create" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      context "when Topic is interestable" do
        before do
          @topic = topic_create
        end
        it "populates @interestable" do
          post topic_interests_path(@topic.id), xhr: true
          expect(assigns(:interestable)).to eq @topic
        end
        it "adds record to Interests" do
          expect{
            post topic_interests_path(@topic.id), xhr: true
          }.to change(Interest, :count).by(1)
        end
        it "user_id of new record is current user" do
          post topic_interests_path(@topic.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.user_id).to eq @user.id
        end
        it "likeable type of new record is Topic" do
          post topic_interests_path(@topic.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.interestable_type).to eq "Topic"
        end
        it "likeable id of new record is topic id" do
          post topic_interests_path(@topic.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.interestable_id).to eq @topic.id
        end
        it "returns a 200 status code" do
          post topic_interests_path(@topic.id), xhr: true
          expect(response).to have_http_status("200")
        end
        
      end
      context "when Neta is interestable" do
        before do
          @neta = neta_create
        end
        it "populates @interestable" do
          post neta_interests_path(@neta.id), xhr: true
          expect(assigns(:interestable)).to eq @neta
        end
        it "adds record to Interest table" do
          expect{
            post neta_interests_path(@neta.id), xhr: true
          }.to change(Interest, :count).by(1)
        end
        it "user_id of new record is current user" do
          post neta_interests_path(@neta.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.user_id).to eq @user.id
        end
        it "likeable type of new record is Neta" do
          post neta_interests_path(@neta.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.interestable_type).to eq "Neta"
        end
        it "likeable id of new record is neta id" do
          post neta_interests_path(@neta.id), xhr: true
          new_interest = Interest.last
          expect(new_interest.interestable_id).to eq @neta.id
        end
        it "returns a 200 status code" do
          post neta_interests_path(@neta.id), xhr: true
          expect(response).to have_http_status("200")
        end
      end
    end
    context "as a guest" do
      context "when Topic is likeable" do
        before do
          @topic = topic_create
        end
        it "returns a 401 status code" do
          post topic_interests_path(@topic.id), xhr: true
          expect(response).to have_http_status("401")
        end
      end
      context "when Neta is likeable" do
        before do
          @neta = neta_create
        end
        it "returns a 401 status code" do
          post topic_interests_path(@neta.id), xhr: true
          expect(response.status).to eq 401
        end
      end
    end
  end
  
  describe "DELETE #destroy" do
    context "as an authenticated user" do
      before do
        @user = user_create
        sign_in @user
      end
      context "when Topic is interestable" do
        before do
          @topic = topic_create
          @interest = Interest.create( interestable: @topic, user: @user )
        end
        it "populates @interestable" do
          delete topic_interest_path(@topic.id, @interest.id), xhr: true
          expect(assigns(:interestable)).to eq @topic
        end
        it "deletes record from Interest table" do
          expect{
            delete topic_interest_path(@topic.id, @interest.id), xhr: true
          }.to change(Interest, :count).by(-1)
        end
        it "returns a 200 status code" do
          delete topic_interest_path(@topic.id, @interest.id), xhr: true
          expect(response).to have_http_status("200")
        end
        context "when current user is not owner of interest" do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it "redirects to topic" do
            delete topic_interest_path(@topic.id, @interest.id), xhr: true
            expect(response).to redirect_to "/topics/#{@topic.id}"
          end
          it "returns a 200 status code" do
            delete topic_interest_path(@topic.id, @interest.id), xhr: true
            expect(response).to have_http_status("200")
          end
        end
      end
      context "when Neta is interestable" do
        before do
          @neta = neta_create
          @interest = Interest.create( interestable: @neta, user: @user )
        end
        it "populates @interestable" do
          delete neta_interest_path(@neta.id, @interest.id), xhr: true
          expect(assigns(:interestable)).to eq @neta
        end
        it "deletes record from Interest table" do
          expect{
            delete neta_interest_path(@neta.id, @interest.id), xhr: true
          }.to change(Interest, :count).by(-1)
        end
        it "returns a 200 status code" do
          delete neta_interest_path(@neta.id, @interest.id), xhr: true
          expect(response).to have_http_status("200")
        end
        context "when current user is not owner of interest" do
          before do
            sign_out @user
            @another_user = FactoryBot.create(:user)
            sign_in @another_user
          end
          it "redirects to neta" do
            delete neta_interest_path(@neta.id, @interest.id), xhr: true
            expect(response).to redirect_to "/netas/#{@neta.id}"
          end
          it "returns a 200 status code" do
            delete neta_interest_path(@neta.id, @interest.id), xhr: true
            expect(response).to have_http_status("200")
          end
        end
      end
    end
  end
  
end
