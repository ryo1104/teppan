require 'rails_helper'

RSpec.describe Authorization, type: :model do
  let(:user_create)             { FactoryBot.create(:user) }
  let(:authorization_create)    { FactoryBot.create(:authorization, :with_user) }
  describe "Validations" do
    it "is valid with a user_id, uid, and provider" do
      authorization = build(:authorization, :with_user)
      expect(authorization).to be_valid
    end
    
    it "is invalid without a user" do
      authorization = build(:authorization, user: nil)
      authorization.valid?
      expect(authorization.errors[:user]).to include("を入力してください")
    end
    
    it "is invalid without a uid" do
      authorization = build(:authorization, :with_user, uid: nil)
      authorization.valid?
      expect(authorization.errors[:uid]).to include("を入力してください。")
    end
    
    it "is invalid without a provider" do
      authorization = build(:authorization, :with_user, provider: nil)
      authorization.valid?
      expect(authorization.errors[:provider]).to include("を入力してください。")
    end
    
    it "is invalid with duplicate pair of uid and provider" do
      create(:authorization, :with_user, uid: "aaaaaaaaaaaa", provider: "bbbbbbbbbbbb")
      authorization = build(:authorization, :with_user, uid: "aaaaaaaaaaaa", provider: "bbbbbbbbbbbb")
      authorization.valid?
      expect(authorization.errors[:uid]).to include("すでにこのユーザーは登録されています。")
    end
  end
  
  describe "method::find_from_auth(auth)" do
    before do
      @authorization = FactoryBot.create(:authorization, :with_user, uid: "abcdef1234", provider: "twitter")
    end
    it "returns authorization instance with valid uid and provider" do
      expect(Authorization.find_from_auth({"uid" => "abcdef1234", "provider" => "twitter"})).to eq @authorization
    end
    it "returns nil with invalid uid" do
      expect(Authorization.find_from_auth({"uid" => "xyz987654", "provider" => "twitter"})).to eq nil
    end
    it "returns nil with blank uid" do
      expect(Authorization.find_from_auth({"uid" => nil, "provider" => "twitter"})).to eq nil
    end
    it "returns nil with invalid provider" do
      expect(Authorization.find_from_auth({"uid" => "abcdef1234", "provider" => "yahoojp"})).to eq nil
    end
    it "returns nil with blank provider" do
      expect(Authorization.find_from_auth({"uid" => "abcdef1234", "provider" => nil})).to eq nil
    end
  end
  
  describe "method::create_from_auth(auth)" do
    before do
      @auth = {"uid" => "abcdef1234", "provider" => "twitter"}
    end
    context "when successful" do
      before do
        @user = user_create
        allow(User).to receive(:create_from_auth!).and_return([true, @user])
      end
      it "creates Authorization from user and auth" do
        expect{Authorization.create_from_auth(@auth)}.to change(Authorization, :count).by(1)
      end
      it "returns true when User and Authorization is created" do
        expect(Authorization.create_from_auth(@auth)[0]).to eq true
      end
      it "returns Authorization object" do
        expect(Authorization.create_from_auth(@auth)[1]).to eq Authorization.last
      end
    end
    context "when failure" do
      before do
        allow(User).to receive(:create_from_auth!).and_return([false, "some error message"])
      end
      it "returns false when failed to create User from auth" do
        expect(Authorization.create_from_auth(@auth)).to eq [false, "failed to create User record"]
      end
      it "returns false when failed to create Authorization from auth" do
        @user = user_create
        allow(User).to receive(:create_from_auth!).and_return([true, @user])
        allow(Authorization).to receive(:create!).and_return(nil)
        expect(Authorization.create_from_auth(@auth)).to eq [false, "failed to create Authorization record"]
      end
    end
    context "Exceptions" do
      it "returns false and exception message when failed to create User" do
        allow(User).to receive(:create_from_auth!).and_raise(StandardError)
        expect(Authorization.create_from_auth(@auth)).to eq [false, "exception rescued while creating User from auth : StandardError"]
      end
      it "returns false and exception message when failed to create Authorization" do
        @user = user_create
        allow(User).to receive(:create_from_auth!).and_return([true, @user])
        allow(Authorization).to receive(:create!).and_raise(StandardError)
        expect(Authorization.create_from_auth(@auth)).to eq [false, "exception rescued while creating Authorization : StandardError"]
      end
    end
  end
end
