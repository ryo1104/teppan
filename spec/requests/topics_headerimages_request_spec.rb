require 'rails_helper'

RSpec.describe Topics::HeaderimagesController, type: :request do
  describe 'DELETE #destroy' do
    subject { delete topic_headerimage_url(@topic.id) }

    context 'if header_img_url field is present' do
      before do
        @user = create(:user)
        sign_in @user
        @topic = create(:topic, user: @user, header_img_url: 'https://amazonaws.com/topic_header_images/dummy_image.jpg')
      end
      it 'header_img_url field is reset to nil' do
        subject
        @topic.reload
        expect(@topic.header_img_url).to eq nil
      end
      it 'redirects to topic edit' do
        subject
        expect(response).to redirect_to edit_topic_url(@topic.id)
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
    end
    context 'if header_img_url field is blank' do
      before do
        @user = create(:user)
        sign_in @user
        @topic = create(:topic, user: @user, header_img_url: nil)
      end
      it 'redirects to topic edit' do
        subject
        expect(response).to redirect_to edit_topic_url(@topic.id)
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
    end
  end
end
