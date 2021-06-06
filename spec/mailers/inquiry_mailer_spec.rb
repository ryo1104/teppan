require 'rails_helper'

RSpec.describe InquiryMailer, type: :mailer do
  describe 'send confirmation email' do
    before do
      ActionMailer::Base.deliveries.clear
      @inquiry = create(:inquiry)
    end

    subject(:mail) { described_class.confirm_email(@inquiry).deliver }

    it 'renders the headers' do
      expect(mail.subject).to eq('[Teppan] お問い合わせありがとうございます')
      expect(mail.to).to eq([@inquiry.email])
      expect(mail.from).to eq(['support@dev.teppan-neta.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('2021 Teppan')
    end
  end
end
