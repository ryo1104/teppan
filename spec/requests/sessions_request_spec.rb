require 'rails_helper'

RSpec.describe "omniauth", type: :request do
  describe "GET #failure" do
    context "for Twitter" do
      before do
        Rails.application.env_config["omniauth.auth"] = twitter_invalid_mock
      end
      subject { get "/auth/twitter/callback" }
      
      it "redirects to sign in page" do
        expect(subject).to redirect_to new_user_session_path
      end
      it "flashes alert message" do
        subject
        expect(flash[:alert]).to eq "外部サービスへの接続に失敗しました。"
      end
    end
    
    context "for YahooJP" do
      before do
        Rails.application.env_config["omniauth.auth"] = yahoojp_invalid_mock
      end
      subject { get "/auth/yahoojp/callback" }
      
      it "redirects to sign in page" do
        expect(subject).to redirect_to new_user_session_path
      end
      it "flashes alert message" do
        subject
        expect(flash[:alert]).to eq "外部サービスへの接続に失敗しました。"
      end
    end
    
    context "for Google" do
      before do
        Rails.application.env_config["omniauth.auth"] = google_oauth2_invalid_mock
      end
      subject { get "/auth/google_oauth2/callback" }
      
      it "redirects to sign in page" do
        expect(subject).to redirect_to new_user_session_path
      end
      it "flashes alert message" do
        subject
        expect(flash[:alert]).to eq "外部サービスへの接続に失敗しました。"
      end
    end
  end
end