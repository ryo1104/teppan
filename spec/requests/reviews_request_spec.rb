require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  let(:user_create)       { create(:user) }
  let(:topic_create)      { create(:topic, :with_user) }
  let(:neta_create)       { create(:neta, :with_user, topic: topic_create) }
  let(:review_attributes) { attributes_for(:review) }

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @neta = neta_create
        @review_attributes = review_attributes
      end
      context 'when review save succeeds' do
        it 'creates a review' do
          expect do
            post neta_reviews_url(@neta.id), params: { review: @review_attributes }
          end.
            to change(Review, :count).by(1)
        end
        it "updates neta's average rate column" do
          another_user = create(:user)
          create(:review, user: another_user, neta: @neta, rate: 2)
          post neta_reviews_url(@neta.id), params: { review: { rate: 5, text: Faker::Lorem.characters(number: 50) } }
          @neta.reload
          expect(@neta.average_rate).to eq 3.5
        end
        it 'redirects to neta#show' do
          post neta_reviews_url(@neta.id), params: { review: @review_attributes }
          expect(response).to redirect_to neta_path(@neta.id)
        end
        context 'but updating neta average rate fails' do
          before do
            allow_any_instance_of(Neta).to receive(:update_average_rate).and_return([false, 'some error message'])
          end
          it 'writes to Rails logger an error message' do
            expect(Rails.logger).to receive(:error).with("some error message. Neta id : #{@neta.id}")
            post neta_reviews_url(@neta.id), params: { review: @review_attributes }
          end
          it 'redirects to neta#show' do
            post neta_reviews_url(@neta.id), params: { review: @review_attributes }
            expect(response).to redirect_to neta_path(@neta.id)
          end
        end
      end
      context 'when review save fails' do
        it 'displays review#new' do
          allow_any_instance_of(Review).to receive(:save).and_return(false)
          post neta_reviews_url(@neta.id), params: { review: @review_attributes }
          expect(response.body).to include '評価して下さい！'
        end
        it 'returns a 200 status code' do
          allow_any_instance_of(Review).to receive(:save).and_return(false)
          post neta_reviews_url(@neta.id), params: { review: @review_attributes }
          expect(response).to have_http_status('200')
        end
      end
    end
    context 'as a guest' do
      before do
        @neta = neta_create
        @review_attributes = review_attributes
      end
      it 'redirects to user sign-in page' do
        post neta_reviews_url(@neta.id), params: { review: @review_attributes }
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'returns a 302 status code' do
        post neta_reviews_url(@neta.id), params: { review: @review_attributes }
        expect(response).to have_http_status('302')
      end
    end
  end
end
