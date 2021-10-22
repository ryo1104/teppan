require 'rails_helper'

RSpec.describe InquiriesController, type: :request do
  let(:inquiry_attributes) { attributes_for(:inquiry) }

  describe 'GET #new' do
    it 'returns a 200 status code' do
      get new_inquiry_url
      expect(response).to have_http_status('200')
    end
  end

  describe 'GET #create' do
    before do
      @attributes = inquiry_attributes
    end
    it 'returns a 200 status code' do
      post inquiries_url, params: { inquiry: { email: @attributes[:email], message: @attributes[:message] } }
      expect(response).to have_http_status('200')
    end
    it 'creates a inquiry record' do
      expect do
        post inquiries_url, params: { inquiry: { email: @attributes[:email], message: @attributes[:message] } }
      end.
        to change(Inquiry, :count).by(1)
    end
    it 'sends email' do
      expect do
        post inquiries_url, params: { inquiry: { email: @attributes[:email], message: @attributes[:message] } }
      end.
        to change { ActionMailer::Base.deliveries.count }.by(1)
    end
    it 'displays page' do
      post inquiries_url, params: { inquiry: { email: @attributes[:email], message: @attributes[:message] } }
      expect(response.body).to include 'お問い合わせ承りました'
    end
    it 'reverts to inquiry page when error' do
      allow_any_instance_of(Inquiry).to receive(:save).and_return(false)
      post inquiries_url, params: { inquiry: { email: @attributes[:email], message: @attributes[:message] } }
      expect(response.body).to include 'お客様（返信先）メールアドレス'
    end
  end
end
