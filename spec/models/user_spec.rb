require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe User, type: :model do
  let(:user_create)           { FactoryBot.create(:user) }
  let(:topic_create)          { FactoryBot.create(:topic, :with_user) }
  let(:account_create)        { FactoryBot.create(:account) }
  let(:test_stripe_cus_id)    { "cus_Fg0CeiufnVMq42" } #けんすけ
  let(:test_stripe_customer)  {
                                {
                                  "id"=>"cus_Fg0CeiufnVMq42",
                                  "object"=>"customer",
                                  "account_balance"=>0,
                                  "address"=>nil,
                                  "balance"=>0,
                                  "created"=>1566572227,
                                  "currency"=>"jpy",
                                  "default_source"=>"card_1FX9FyEThOtNwrS9uOsjxpPw",
                                  "delinquent"=>false,
                                  "description"=>nil,
                                  "discount"=>nil,
                                  "email"=>"kenske@hoge.com",
                                  "invoice_prefix"=>"6B9C3876",
                                  "invoice_settings"=>{"custom_fields"=>nil, "default_payment_method"=>nil, "footer"=>nil},
                                  "livemode"=>false,
                                  "metadata"=>{},
                                  "name"=>"ケンスケ",
                                  "phone"=>nil,
                                  "preferred_locales"=>[],
                                  "shipping"=>nil,
                                  "sources"=>{
                                    "object"=>"list",
                                    "data"=>
                                      [
                                        {"id"=>"card_1FX9FyEThOtNwrS9uOsjxpPw",
                                          "object"=>"card",
                                          "address_city"=>nil,
                                          "address_country"=>nil,
                                          "address_line1"=>nil,
                                          "address_line1_check"=>nil,
                                          "address_line2"=>nil,
                                          "address_state"=>nil,
                                          "address_zip"=>nil,
                                          "address_zip_check"=>nil,
                                          "brand"=>"American Express",
                                          "country"=>"US",
                                          "customer"=>"cus_Fg0CeiufnVMq42",
                                          "cvc_check"=>"pass",
                                          "dynamic_last4"=>nil,
                                          "exp_month"=>11,
                                          "exp_year"=>2023,
                                          "fingerprint"=>"vSoz8Q9JqQn12q1b",
                                          "funding"=>"credit",
                                          "last4"=>"0005",
                                          "metadata"=>{},
                                          "name"=>"kenske@hoge.com",
                                          "tokenization_method"=>nil},
                                        {"id"=>"card_1FX9BuEThOtNwrS9sDa03dMX",
                                          "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"Visa", "country"=>"US", "customer"=>"cus_Fg0CeiufnVMq42", "cvc_check"=>"pass", "dynamic_last4"=>nil, "exp_month"=>11, "exp_year"=>2022, "fingerprint"=>"Itr9EOwed6Uv7XLI", "funding"=>"credit", "last4"=>"4242", "metadata"=>{}, "name"=>"kenske@hoge.com", "tokenization_method"=>nil},
                                        {"id"=>"card_1FAeCKEThOtNwrS9wL4emYDs",
                                          "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"MasterCard", "country"=>"US", "customer"=>"cus_Fg0CeiufnVMq42", "cvc_check"=>"pass", "dynamic_last4"=>nil, "exp_month"=>11, "exp_year"=>2022, "fingerprint"=>"cFnZM3vfXfzy0h2R", "funding"=>"credit", "last4"=>"4444", "metadata"=>{}, "name"=>"kenske@hoge.com", "tokenization_method"=>nil}
                                      ],
                                    "has_more"=>false,
                                    "total_count"=>3,
                                    "url"=>"/v1/customers/cus_Fg0CeiufnVMq42/sources"
                                  },
                                  "subscriptions"=>{
                                    "object"=>"list",
                                    "data"=>
                                      [
                                        {"id"=>"sub_Fg0CdeP2FTlclT",
                                        "object"=>"subscription",
                                          "application_fee_percent"=>nil,
                                          "billing"=>"charge_automatically",
                                          "billing_cycle_anchor"=>1567177028,
                                          "billing_thresholds"=>nil,
                                          "cancel_at"=>nil,
                                          "cancel_at_period_end"=>false,
                                          "canceled_at"=>nil,
                                          "collection_method"=>"charge_automatically",
                                          "created"=>1566572228,
                                          "current_period_end"=>1572620228,
                                          "current_period_start"=>1572015428,
                                          "customer"=>"cus_Fg0CeiufnVMq42",
                                          "days_until_due"=>nil,
                                          "default_payment_method"=>nil,
                                          "default_source"=>"card_1FAeCKEThOtNwrS9wL4emYDs",
                                          "default_tax_rates"=>[],
                                          "discount"=>nil,
                                          "ended_at"=>nil,
                                          "items"=>{
                                            "object"=>"list",
                                            "data"=>
                                              [
                                                {
                                                  "id"=>"si_Fg0CYt5vVzkTPj",
                                                  "object"=>"subscription_item",
                                                  "billing_thresholds"=>nil,
                                                  "created"=>1566572228,
                                                  "metadata"=>{},
                                                  "plan"=>{
                                                    "id"=>"plan_F8dqnFoGCwICvt",
                                                    "object"=>"plan",
                                                    "active"=>true,
                                                    "aggregate_usage"=>nil,
                                                    "amount"=>200,
                                                    "amount_decimal"=>"200",
                                                    "billing_scheme"=>"per_unit",
                                                    "created"=>1558877937,
                                                    "currency"=>"jpy",
                                                    "interval"=>"week",
                                                    "interval_count"=>1,
                                                    "livemode"=>false,
                                                    "metadata"=>{},
                                                    "nickname"=>"週次",
                                                    "product"=>"prod_Ero9sCJdCklOgm",
                                                    "tiers"=>nil,
                                                    "tiers_mode"=>nil,
                                                    "transform_usage"=>nil,
                                                    "trial_period_days"=>7,
                                                    "usage_type"=>"licensed"
                                                  },
                                                  "quantity"=>1,
                                                  "subscription"=>"sub_Fg0CdeP2FTlclT",
                                                  "tax_rates"=>[]
                                                }
                                              ],
                                              "has_more"=>false,
                                              "total_count"=>1,
                                              "url"=>"/v1/subscription_items?subscription=sub_Fg0CdeP2FTlclT"
                                          },
                                          "latest_invoice"=>"in_1FXUE4EThOtNwrS9pwqflNUv",
                                          "livemode"=>false,
                                          "metadata"=>{},
                                          "next_pending_invoice_item_invoice"=>nil,
                                          "pending_invoice_item_interval"=>nil,
                                          "pending_setup_intent"=>nil,
                                          "plan"=>{
                                            "id"=>"plan_F8dqnFoGCwICvt",
                                            "object"=>"plan",
                                            "active"=>true,
                                            "aggregate_usage"=>nil,
                                            "amount"=>200,
                                            "amount_decimal"=>"200",
                                            "billing_scheme"=>"per_unit",
                                            "created"=>1558877937,
                                            "currency"=>"jpy",
                                            "interval"=>"week",
                                            "interval_count"=>1,
                                            "livemode"=>false,
                                            "metadata"=>{},
                                            "nickname"=>"週次",
                                            "product"=>"prod_Ero9sCJdCklOgm",
                                            "tiers"=>nil,
                                            "tiers_mode"=>nil,
                                            "transform_usage"=>nil,
                                            "trial_period_days"=>7,
                                            "usage_type"=>"licensed"
                                          },
                                          "quantity"=>1,
                                          "schedule"=>nil,
                                          "start"=>1566572228,
                                          "start_date"=>1566572228,
                                          "status"=>"active",
                                          "tax_percent"=>nil,
                                          "trial_end"=>1567177028,
                                          "trial_start"=>1566572228
                                        }
                                      ],
                                      "has_more"=>false,
                                      "total_count"=>1,
                                      "url"=>"/v1/customers/cus_Fg0CeiufnVMq42/subscriptions"
                                  },
                                  "tax_exempt"=>"none",
                                  "tax_ids"=>{
                                    "object"=>"list",
                                    "data"=>[],
                                    "has_more"=>false,
                                    "total_count"=>0,
                                    "url"=>"/v1/customers/cus_Fg0CeiufnVMq42/tax_ids"
                                  },
                                  "tax_info"=>nil,
                                  "tax_info_verification"=>nil
                                }}
  let(:test_stripe_cards)     {
                                {
                                  "object"=>"list", 
                                  "data"=>[
                                    {"id"=>"card_1FX9FyEThOtNwrS9uOsjxpPw", "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"American Express", "country"=>"US", "customer"=>"cus_Fg0CeiufnVMq42", "cvc_check"=>"pass", "dynamic_last4"=>nil, "exp_month"=>11, "exp_year"=>2023, "fingerprint"=>"vSoz8Q9JqQn12q1b", "funding"=>"credit", "last4"=>"0005", "metadata"=>{}, "name"=>"kenske@hoge.com", "tokenization_method"=>nil}, 
                                    {"id"=>"card_1FX9BuEThOtNwrS9sDa03dMX", "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"Visa", "country"=>"US", "customer"=>"cus_Fg0CeiufnVMq42", "cvc_check"=>"pass", "dynamic_last4"=>nil, "exp_month"=>11, "exp_year"=>2022, "fingerprint"=>"Itr9EOwed6Uv7XLI", "funding"=>"credit", "last4"=>"4242", "metadata"=>{}, "name"=>"kenske@hoge.com", "tokenization_method"=>nil}, 
                                    {"id"=>"card_1FAeCKEThOtNwrS9wL4emYDs", "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"MasterCard", "country"=>"US", "customer"=>"cus_Fg0CeiufnVMq42", "cvc_check"=>"pass", "dynamic_last4"=>nil, "exp_month"=>11, "exp_year"=>2022, "fingerprint"=>"cFnZM3vfXfzy0h2R", "funding"=>"credit", "last4"=>"4444", "metadata"=>{}, "name"=>"kenske@hoge.com", "tokenization_method"=>nil}],
                                  "has_more"=>false, 
                                  "url"=>"/v1/customers/cus_Fg0CeiufnVMq42/sources"
                                }
                              }
  let(:test_stripe_card_id_1) { "card_1FX9FyEThOtNwrS9uOsjxpPw" }
  let(:test_stripe_card)      {
                                {
                                  "id"=>"card_1FX9FyEThOtNwrS9uOsjxpPw",
                                  "object"=>"card",
                                  "address_city"=>nil,
                                  "address_country"=>nil,
                                  "address_line1"=>nil,
                                  "address_line1_check"=>nil,
                                  "address_line2"=>nil,
                                  "address_state"=>nil,
                                  "address_zip"=>nil,
                                  "address_zip_check"=>nil,
                                  "brand"=>"American Express",
                                  "country"=>"US",
                                  "customer"=>"cus_Fg0CeiufnVMq42",
                                  "cvc_check"=>"pass",
                                  "dynamic_last4"=>nil,
                                  "exp_month"=>11,
                                  "exp_year"=>2023,
                                  "fingerprint"=>"vSoz8Q9JqQn12q1b",
                                  "funding"=>"credit",
                                  "last4"=>"0005",
                                  "metadata"=>{},
                                  "name"=>"kenske@hoge.com",
                                  "tokenization_method"=>nil
                                } 
                              }

  let(:test_stripe_cus_id_2)  { "cus_FGwAu264LHTBMA" } #たろう
  let(:test_stripe_card_id_2) { "card_1FX9BuEThOtNwrS9sDa03dMX" }
  let(:test_stripe_card_2)    {
                                {"id"=>"card_1FYCdDEThOtNwrS9SCkZDw4V", "object"=>"card", "address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "brand"=>"Visa", "country"=>"JP", "customer"=>"cus_FGwAu264LHTBMA", "cvc_check"=>nil, "dynamic_last4"=>nil, "exp_month"=>10, "exp_year"=>2020, "fingerprint"=>"KaeQWgsMtmfoUXNy", "funding"=>"credit", "last4"=>"0003", "metadata"=>{}, "name"=>nil, "tokenization_method"=>nil}
                              }
  let(:test_stripe_acct_id)   { "acct_1FHvBMCx2rPekxgm" } #けんすけ
  let(:stripe_balance_obj)    { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}],
                                  "livemode"=>false,
                                  "pending"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}]
                                }
                              }
  let(:stripe_balance_obj_corrupt) { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{}],
                                  "livemode"=>false
                                }
                              }
  let(:valid_stripe_acct_id)  { "acct_1ETuuMKRzI9hdj1X" } #ゆうたろう
  
  describe "Validations" do
    it "is valid with a nickname, email, and password" do
      user = build(:user)
      expect(user).to be_valid
    end
  
    it "is invalid without an email address" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください。")
    end
    
    it "is invalid with a duplicate email address" do
      create(:user, email: "aaa@hoge.com", nickname: "tarou")
      user = build(:user, email: "aaa@hoge.com", nickname: "hiroshi")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します。")
    end
    
    it "is invalid if gender code is smaller than 1" do
      user = build(:user, gender: 0)
      user.valid?
      expect(user.errors[:gender]).to include("Invalid gender code")
    end
    
    it "is invalid if gender code is greater than 2" do
      user = build(:user, gender: 3)
      user.valid?
      expect(user.errors[:gender]).to include("Invalid gender code")
    end
    
    it "is invalid if prefecture code is smaller than 1" do
      user = build(:user, prefecture_code: 0)
      user.valid?
      expect(user.errors[:prefecture_code]).to include("Invalid prefecture code") 
    end
    
    it "is invalid if prefecture code is greater than 47" do
      user = build(:user, prefecture_code: 48)
      user.valid?
      expect(user.errors[:prefecture_code]).to include("Invalid prefecture code") 
    end
    
    it "is invalid if age is less than 13 years old" do
      testdate = Time.zone.today.prev_year(13) + 1.day
      user = build(:user, birthdate: testdate)
      user.valid?
      expect(user.errors[:birthdate]).to include("１３歳未満は登録できません。")
    end
    
    it "is invalid if introduction is longer than 800 characters" do
      user = build(:user, introduction: Faker::Lorem.characters(number: 801))
      user.valid?
      expect(user.errors[:introduction]).to include("は800文字以内で入力してください。")
    end
  
    it "is invalid if stripe_cus_id does not start with cus_" do
      user = build(:user, stripe_cus_id: "aaa_"+Faker::Lorem.characters(number: 14))
      user.valid?
      expect(user.errors[:stripe_cus_id]).to include("invalid stripe_cus_id")
    end
    
    it "is invalid if duplicate stripe_cus_id exists"
    
    it "is invalid if follows_count is negative" do
      user = build(:user, follows_count: -1)
      user.valid?
      expect(user.errors[:follows_count]).to include("は0以上の値にしてください。")
    end
    
    it "is invalid if unsupported file type for image was attached" do
      user = FactoryBot.create(:user, nickname: nil, gender: nil, prefecture_code: nil, birthdate: nil, introduction: nil)
      file = fixture_file_upload('/files/トラ.gif', 'image/gif')
      user.image.attach(file)
      expect(user.errors[:image]).to include("の拡張子が間違っています")
    end
  end

  describe "method::create_from_auth!(auth)" do
    it "returns false if auth is blank" do
      result = User.create_from_auth!(nil)
      expect(result).to match [false, "auth is empty"]
    end
    it "returns false if unknown provider" do
      auth = {"provider" => nil}
      result = User.create_from_auth!(auth)
      expect(result).to match [false, "unknown provider"]
    end
    context "for YahooJP" do
      before do
        @auth = yahoojp_mock
      end
      it "sets email" do
        result = User.create_from_auth!(@auth)
        expect(result[1].email).to eq "mockuser@yahoo.co.jp"
      end
      it "sets nickname" do
        result = User.create_from_auth!(@auth)
        expect(result[1].nickname).to eq "mockuser"
      end
      it "gender code is set as 1 when male" do
        @auth["info"]["gender"] = "male"
        result = User.create_from_auth!(@auth)
        expect(result[1].gender).to eq 1
      end
      it "gender code is set as 2 when female" do
        @auth["info"]["gender"] = "female"
        result = User.create_from_auth!(@auth)
        expect(result[1].gender).to eq 2
      end
      it "gender code is set as nil when unavailable" do
        @auth["info"]["gender"] = nil
        result = User.create_from_auth!(@auth)
        expect(result[1].gender).to eq nil
      end
      it "prefecture code is set as nil when country is not jp" do
        @auth["info"]["address"]["country"] = "us"
        result = User.create_from_auth!(@auth)
        expect(result[1].prefecture_code).to eq nil
      end
      it "prefecture code is set for valid prefecture name" do
        result = User.create_from_auth!(@auth)
        expect(result[1].prefecture_code).to eq 47
      end
      it "prefecture code is set as nil for invalid prefecture name" do
        @auth["info"]["address"]["region"] = "名古屋市"
        result = User.create_from_auth!(@auth)
        expect(result[1].prefecture_code).to eq nil
      end
      it "prefecture code is set as nil when unavailable" do
        @auth["info"]["address"]["region"] = nil
        result = User.create_from_auth!(@auth)
        expect(result[1].prefecture_code).to eq nil
      end
      it "creates user" do
        result = User.create_from_auth!(@auth)
        the_new_user = User.last
        expect(result[1]).to eq the_new_user
      end
      it "returns true" do
        result = User.create_from_auth!(@auth)
        expect(result[0]).to eq true
      end
      it "returns error when user was not created" do
        allow(User).to receive(:create!).and_return(nil)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("failed to create user")
      end
      it "returns error when exception raised" do
        allow(User).to receive(:create!).and_raise(StandardError)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("exception rescued while creating User")
      end
    end
    context "for Twitter" do
      before do
        @auth = twitter_mock
      end
      it "sets email"
      it "sets nickname" do
        result = User.create_from_auth!(@auth)
        expect(result[1].nickname).to eq "MockTwitterUser"
      end
      it "creates user" do
        result = User.create_from_auth!(@auth)
        the_new_user = User.last
        expect(result[1]).to eq the_new_user
      end
      it "returns true" do
        result = User.create_from_auth!(@auth)
        expect(result[0]).to eq true
      end
      it "returns error when user was not created" do
        allow(User).to receive(:create!).and_return(nil)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("failed to create user")
      end
      it "returns error when exception raised" do
        allow(User).to receive(:create!).and_raise(StandardError)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("exception rescued while creating User")
      end
    end
    context "Google" do
      before do
        @auth = google_oauth2_mock
      end
      it "sets email" do
        result = User.create_from_auth!(@auth)
        expect(result[1].email).to eq "mockuser@gmail.com"
      end
      it "sets nickname" do
        result = User.create_from_auth!(@auth)
        expect(result[1].nickname).to eq "mockuser"
      end
      it "creates user" do
        result = User.create_from_auth!(@auth)
        the_new_user = User.last
        expect(result[1]).to eq the_new_user
      end
      it "returns true" do
        result = User.create_from_auth!(@auth)
        expect(result[0]).to eq true
      end
      it "returns error when user was not created" do
        allow(User).to receive(:create!).and_return(nil)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("failed to create user")
      end
      it "returns error when exception raised" do
        allow(User).to receive(:create!).and_raise(StandardError)
        result = User.create_from_auth!(@auth)
        expect(result[1]).to include("exception rescued while creating User")
      end
    end
  end
  
  describe "method::avatar" do
    it "returns saved image if exists"
    it "returns no_user_image.jpg if no image saved"
  end
  
  describe "method::age" do
    it "returns hyphen when birthdate is blank" do
      @user = FactoryBot.create(:user, birthdate: nil)
      expect(@user.age).to eq " - "
    end
    it "returns current age (without rounding up)" do
      real_age = 15.6
      seconds_from_birth = (real_age * 365.25 * 24 * 60 * 60).floor
      birthdate = Time.zone.now - seconds_from_birth
      @user = FactoryBot.create(:user, birthdate: Time.zone.at(birthdate))
      expect(@user.age).to eq 15
    end
    it "returns nil when age calc result is not positive" do
      @user = FactoryBot.create(:user)
      @user.birthdate = Time.zone.today
      expect(@user.age).to eq nil
    end
  end
  
  describe "method::gender_str" do
    it "returns 男性 when 1" do
      @user = FactoryBot.create(:user, gender: 1)
      expect(@user.gender_str).to eq "男性"
    end
    it "returns 女性 when 2" do
      @user = FactoryBot.create(:user, gender: 2)
      expect(@user.gender_str).to eq "女性"
    end
    it "returns hyphen when neither 1 or 2" do
      @user = FactoryBot.create(:user)
      @user.gender = 3
      expect(@user.gender_str).to eq " - "
    end
    it "returns hyphen when blank" do
      @user = FactoryBot.create(:user, gender: nil)
      expect(@user.gender_str).to eq " - "
    end
  end
  
  describe "method::prefecture_name" do
    it "returns prefecture name for valid prefecture code" do
      @user = FactoryBot.create(:user, prefecture_code: 1)
      expect(@user.prefecture_name).to eq "北海道"
    end
    it "returns hyphen for invalid prefecture code" do
      @user = FactoryBot.create(:user, prefecture_code: nil)
      expect(@user.prefecture_name).to eq " - "
    end
  end
  
  describe "method::following_users" do
    before do
      @follower = FactoryBot.create(:user)
    end
    
    it "returns following user list" do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @user3 = FactoryBot.create(:user)
      @user4 = FactoryBot.create(:user)
      @follow1 = FactoryBot.create(:follow, user: @user1, follower_id: @follower.id )
      @follow2 = FactoryBot.create(:follow, user: @user2, follower_id: @follower.id )
      @follow3 = FactoryBot.create(:follow, user: @user3, follower_id: @user1.id )
      @follow4 = FactoryBot.create(:follow, user: @user1, follower_id: @user4.id )
      @follow5 = FactoryBot.create(:follow, user: @user4, follower_id: @follower.id )
      users = User.where(id: [@user1.id, @user2.id, @user4.id])
      expect(@follower.following_users).to match users
    end
    
    it "returns blank (=> Active Record::Relation []) when user is not following anyone" do
      expect(@follower.following_users).to be_empty
    end
  end
  
  describe "method::following_users_count" do
    before do
      @follower = FactoryBot.create(:user)
    end
    
    it "returns following user count" do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @user3 = FactoryBot.create(:user)
      @user4 = FactoryBot.create(:user)
      @follow1 = FactoryBot.create(:follow, user: @user1, follower_id: @follower.id )
      @follow2 = FactoryBot.create(:follow, user: @user2, follower_id: @follower.id )
      @follow3 = FactoryBot.create(:follow, user: @user3, follower_id: @user1.id )
      @follow4 = FactoryBot.create(:follow, user: @user1, follower_id: @user4.id )
      @follow5 = FactoryBot.create(:follow, user: @user4, follower_id: @follower.id )
      expect(@follower.following_users_count).to eq 3
    end
    
    it "returns 0 when user is not following anyone" do
      expect(@follower.following_users_count).to eq 0
    end
  end
  
  describe "method::followed_users" do
    before do
      @user = FactoryBot.create(:user)
    end
    
    it "returns followed user list" do
      @follower1 = FactoryBot.create(:user)
      @follower2 = FactoryBot.create(:user)
      @follower3 = FactoryBot.create(:user)
      @follower4 = FactoryBot.create(:user)
      @follow1 = FactoryBot.create(:follow, user: @user, follower_id: @follower1.id )
      @follow2 = FactoryBot.create(:follow, user: @user, follower_id: @follower2.id )
      @follow3 = FactoryBot.create(:follow, user: @follower1, follower_id: @follower3.id )
      @follow4 = FactoryBot.create(:follow, user: @follower3, follower_id: @follower4.id )
      @follow5 = FactoryBot.create(:follow, user: @user, follower_id: @follower4.id )
      users = User.where(id: [@follower1.id, @follower2.id, @follower4.id])
      expect(@user.followed_users).to match users
    end
    
    it "returns blank (=> Active Record::Relation []) when user is not followed by anyone" do
      expect(@user.followed_users).to be_empty
    end
  end
  
  describe "method::is_followed_by(user_id)" do
    before do
      @user = FactoryBot.create(:user)
      @follower = FactoryBot.create(:user)
    end
    
    it "returns true if user is already followed by follower" do
      @follow = FactoryBot.create(:follow, user: @user, follower_id: @follower.id )
      expect(@user.is_followed_by(@follower.id)).to eq true
    end
    
    it "returns false if user is not followed by follower" do
      expect(@user.is_followed_by(@follower.id)).to eq false
    end
  end
  
  describe "method::is_blocked_by(user_id)" do
    before do
      @user = FactoryBot.create(:user)
      @reporter = FactoryBot.create(:user)
    end
    
    it "returns true if user is already blocked by follower" do
      @violation = FactoryBot.create(:violation, user: @user, reporter_id: @reporter.id )
      expect(@user.is_blocked_by(@reporter.id)).to eq true
    end
    
    it "returns false if user is not blocked by follower" do
      expect(@user.is_blocked_by(@reporter.id)).to eq false
    end
  end
  
  describe "method::average_rate" do
    before do
      @user = user_create
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @topic3 = FactoryBot.create(:topic, :with_user)
    end
    it "returns average rate of user's netas" do
      FactoryBot.create(:neta, user: @user, topic: @topic1, reviews_count: 3, average_rate: 3.11)
      FactoryBot.create(:neta, user: @user, topic: @topic2, reviews_count: 5, average_rate: 3.72)
      FactoryBot.create(:neta, user: @user, topic: @topic3, reviews_count: 1, average_rate: 0)
      expect(@user.average_rate).to eq ((3.11*3+3.72*5+0)/(3+5+1)).round(2)
    end
    it "returns 0 when no netas by user" do
      expect(@user.average_rate).to eq "-"
    end
  end
  
  describe "method::free_netas" do
    before do
      @user = user_create
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @topic3 = FactoryBot.create(:topic, :with_user)
    end
    it "returns netas with zero price" do
      FactoryBot.create(:neta, user: @user, topic: @topic1, reviews_count: 3, price: 0)
      FactoryBot.create(:neta, user: @user, topic: @topic2, reviews_count: 5, price: 0)
      FactoryBot.create(:neta, user: @user, topic: @topic3, reviews_count: 2, price: 0)
      FactoryBot.create(:neta, user: @user, topic: @topic3, reviews_count: 1, price: 200)
      netas = Neta.where(user_id: @user.id).where(price: 0)
      expect(@user.free_netas).to match netas
    end
    it "returns blank (=> Active Record::Relation []) when no free netas exist" do
      expect(@user.free_netas).to be_empty
    end
  end
  
  describe "method::profile_gauge", type: :doing do
    it "returns 0 when no profile info" do
      user = FactoryBot.create(:user, nickname: nil, gender: nil, prefecture_code: nil, birthdate: nil, introduction: nil)
      expect(user.profile_gauge).to eq 0
    end
    it "returns 16 when avatar attachment exists" do
      user = FactoryBot.create(:user, nickname: nil, gender: nil, prefecture_code: nil, birthdate: nil, introduction: nil)
      file = fixture_file_upload('/files/トラ.jpg', 'image/jpeg')
      # /rails_root/spec/fixtures/files/トラ.jpg
      user.image.attach(file)
      expect(user.profile_gauge).to eq 16
    end
    it "returns 100 when all profile info exists" do
      user = FactoryBot.create(:user)
      file = fixture_file_upload('/files/トラ.jpg', 'image/jpeg')
      # /rails_root/spec/fixtures/files/トラ.jpg
      user.image.attach(file)
      expect(user.profile_gauge).to eq 100
    end
  end
  
  describe "method::premium_user" do
    before do
      @user = user_create
      @topic = topic_create
    end
    context "user does not have 3 or more free netas" do
      before do
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0)
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0)
        @netas = Neta.where(user: @user)
      end
      it "returns false" do
        expect(@user.premium_user[0]).to eq false
      end
      it "returns nil for average rate" do
        expect(@user.premium_user[1]).to eq nil
      end
      it "returns netas" do
        expect(@user.premium_user[2]).to eq @netas
      end
    end
    context "user has 3 free netas but average rating is below 3" do
      before do
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 3.01)
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 3)
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 2.97)
        @netas = Neta.where(user: @user)
      end
      it "returns false" do
        expect(@user.premium_user[0]).to eq false
      end
      it "returns average rate below 3" do
        expect(@user.premium_user[1]).to eq 2.99
      end
      it "returns netas" do
        expect(@user.premium_user[2]).to eq @netas
      end
    end
    context "user has 3 or more free netas with average rate 3 or above" do
      before do
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 3.01)
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 3)
        FactoryBot.create(:neta, user: @user, topic: @topic, price: 0, reviews_count: 3, average_rate: 2.98)
        @netas = Neta.where(user: @user)
      end
      it "returns true" do
        expect(@user.premium_user[0]).to eq true
      end
      it "returns average rate of 3 or above" do
        expect(@user.premium_user[1]).to eq 3.00
      end
      it "returns netas" do
        expect(@user.premium_user[2]).to eq @netas
      end
    end
  end
  
  describe "method::premium_qualified" do
    before do
      @user = user_create
    end
    context "user is premium user" do
      before do
        allow_any_instance_of(User).to receive(:premium_user).and_return([true, 3, nil])
      end
      context "and has a account with verified status" do
        before do
          FactoryBot.create(:account, user: @user, stripe_status: "verified")
        end
        it "returns true" do
          expect(@user.premium_qualified).to eq true
        end
      end
      context "and has a account with unverified status" do
        before do
          FactoryBot.create(:account, user: @user, stripe_status: "unverified")
        end
        it "returns false" do
          expect(@user.premium_qualified).to eq false
        end
      end
      context "but does not have an account" do
        it "returns false" do
          expect(@user.premium_qualified).to eq false
        end
      end
    end
    context "user is not premium user" do
      before do
        allow_any_instance_of(User).to receive(:premium_user).and_return([false, 2, nil])
      end
      it "returns false" do
        expect(@user.premium_qualified).to eq false
      end
    end
  end
  
  describe "method::bought_netas" do
    before do
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @neta1 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic1)
      @neta2 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic1)
      @neta3 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic2)
      @neta4 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic2)
    end
    it "returns bought netas" do
      FactoryBot.create(:trade, tradeable: @neta1, buyer_id: @user1.id, seller_id: @neta1.user.id)
      FactoryBot.create(:trade, tradeable: @neta2, buyer_id: @user1.id, seller_id: @neta2.user.id)
      FactoryBot.create(:trade, tradeable: @neta2, buyer_id: @user2.id, seller_id: @neta2.user.id)
      FactoryBot.create(:trade, tradeable: @neta3, buyer_id: @user2.id, seller_id: @neta3.user.id)
      trades = Trade.where(buyer_id: @user1.id)
      netas = Neta.where(topic: @topic1)
      expect(User.bought_netas(trades)).to match_array netas
    end
    it "returns blank (=> Active Record::Relation []) when no bought netas exist" do
      FactoryBot.create(:trade, tradeable: @neta2, buyer_id: @user2.id, seller_id: @neta2.user.id)
      FactoryBot.create(:trade, tradeable: @neta3, buyer_id: @user2.id, seller_id: @neta3.user.id)
      trades = Trade.where(buyer_id: @user1.id)
      expect(User.bought_netas(trades)).to be_empty
    end
    it "filters for only Netas and no other tradeable"
  end
  
  describe "method::interested_netas" do
    before do
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @neta1 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic1)
      @neta2 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic1)
      @neta3 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic2)
      @neta4 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic2)
    end
    it "returns interested netas" do
      FactoryBot.create(:interest, interestable: @neta1, user: @user1)
      FactoryBot.create(:interest, interestable: @neta2, user: @user1)
      FactoryBot.create(:interest, interestable: @neta2, user: @user2)
      FactoryBot.create(:interest, interestable: @neta3, user: @user2)
      netas = Neta.where(topic: @topic1)
      expect(@user1.interested_netas).to match_array netas
    end
    it "returns blank (=> Active Record::Relation []) when no interested netas exist" do
      FactoryBot.create(:interest, interestable: @neta2, user: @user2)
      FactoryBot.create(:interest, interestable: @neta3, user: @user2)
      expect(@user1.interested_netas).to be_empty
    end
    it "filters for only Netas and no other interestable" do
      FactoryBot.create(:interest, interestable: @neta1, user: @user1)
      FactoryBot.create(:interest, interestable: @neta2, user: @user1)
      FactoryBot.create(:interest, interestable: @neta2, user: @user2)
      FactoryBot.create(:interest, interestable: @neta3, user: @user2)
      FactoryBot.create(:interest, interestable: @topic1, user: @user1)
      netas = Neta.where(topic: @topic1)
      expect(@user1.interested_netas).to match_array netas
    end
  end
  
  describe "method::interested_topics" do
    before do
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @topic3 = FactoryBot.create(:topic, :with_user)
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
    end
    it "returns interested topics" do
      FactoryBot.create(:interest, interestable: @topic1, user: @user1)
      FactoryBot.create(:interest, interestable: @topic1, user: @user2)
      FactoryBot.create(:interest, interestable: @topic2, user: @user1)
      FactoryBot.create(:interest, interestable: @topic3, user: @user2)
      topics = Topic.where(id: @topic1.id).or(Topic.where(id: @topic2.id))
      expect(@user1.interested_topics).to match_array topics
    end
    it "returns blank (=> Active Record::Relation []) when no interested topics exist" do
      FactoryBot.create(:interest, interestable: @topic1, user: @user2)
      FactoryBot.create(:interest, interestable: @topic2, user: @user2)
      expect(@user1.interested_topics).to be_empty
    end
    it "filters for only Topics and no other interestable" do
      FactoryBot.create(:interest, interestable: @topic1, user: @user1)
      FactoryBot.create(:interest, interestable: @topic1, user: @user2)
      FactoryBot.create(:interest, interestable: @topic2, user: @user1)
      FactoryBot.create(:interest, interestable: @topic3, user: @user2)
      @neta1 = FactoryBot.create(:neta, :with_user, :with_valuetext, topic: @topic1)
      FactoryBot.create(:interest, interestable: @neta1, user: @user1)
      topics = Topic.where(id: @topic1.id).or(Topic.where(id: @topic2.id))
      expect(@user1.interested_topics).to match_array topics
    end
  end
  
  describe "method::get_customer" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "user with valid cus_id" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
        @customer = JSON.parse(Stripe::Customer.retrieve(@user.stripe_cus_id).to_s)
      end
      it "retrieves customer info" do
        expect(@user.get_customer).to eq [true, @customer]
      end
    end
    context "user with invalid cus_id" do
      before do
        @user.stripe_cus_id = "aaaaaa"
      end
      it "returns false when no such cus_id exists" do
        expect(@user.get_customer).to eq [false, "Stripe error - No such customer: #{@user.stripe_cus_id}"]
      end
    end
    context "user with blank cus_id" do
      before do
        @user.stripe_cus_id = nil
      end
      it "returns false" do
        expect(@user.get_customer).to eq [false, "stripe_cus_id is blank"]
      end
    end
  end
  
  describe "method::get_cards" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "user with valid cus_id" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
      end
      it "retrieves cards info" do
        expect(@user.get_cards).to eq [true, test_stripe_cards]
      end
    end
    context "user with invalid cus_id" do
      before do
        @user.stripe_cus_id = "bbbbbb"
      end
      it "returns false when no such cus_id exists" do
        expect(@user.get_cards).to eq [false, "Stripe error - No such customer: #{@user.stripe_cus_id}"]
      end
    end
    context "user with blank cus_id" do
      before do
        @user.stripe_cus_id = nil
      end
      it "returns false" do
        expect(@user.get_cards).to eq [false, "stripe_cus_id is blank"]
      end
    end
  end
  
  describe "method::get_card_details" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "user with valid cus_id" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
      end
      context "card_id is valid" do
        before do
          @card_id = test_stripe_card_id_1
        end
        it "retrieves card details" do
          expect(@user.get_card_details(@card_id)).to eq [true, test_stripe_card]
        end
      end
      context "card_id is invalid" do
        before do
          @card_id = "cccccc"
        end
        it "returns false when card_id does not exist on user" do
          expect(@user.get_card_details(@card_id)).to eq [false, "Stripe error - No such source: #{@card_id}"]
        end
        it "returns false when card_id is blank" do
          expect(@user.get_card_details(nil)).to eq [false, "card_id is blank"]
        end
      end
    end
    context "user with invalid cus_id" do
      before do
        @user.stripe_cus_id = "dddddd"
        @card_id = test_stripe_card_id_1
      end
      it "returns false" do
        expect(@user.get_card_details(@card_id)).to eq [false, "Stripe error - No such customer: #{@user.stripe_cus_id}"]
      end
    end
    context "user with blank cus_id" do
      before do
        @user.stripe_cus_id = nil
        @card_id = test_stripe_card_id_1
      end
      it "returns false" do
        expect(@user.get_card_details(@card_id)).to eq [false, "stripe_cus_id is blank"]
      end
    end
  end
  
  describe "method::add_card" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "user with valid cus_id" do
      context "token is blank" do
        it "returns false" do
          expect(@user.add_card(nil)).to eq [false, "token is blank"]
        end
      end
      context "token is valid" do
        before do
          @token = "tok_jp"
          @user.stripe_cus_id = test_stripe_cus_id_2
          allow_any_instance_of(User).to receive(:change_default_card).and_return([true, nil])
        end
        it "returns added card" do
          @added_card = @user.add_card(@token)
          expect(@added_card[1]["object"]).to eq "card"
        end
        after do
          Stripe::Customer.delete_source(@user.stripe_cus_id, @added_card[1]["id"])
        end
      end
      context "token is invalid" do
        before do
          @user.stripe_cus_id = test_stripe_cus_id_2
          allow_any_instance_of(User).to receive(:change_default_card).and_return([true, nil])
        end
        it "returns false when CvC check fails" do
          @token = "tok_cvcCheckFail"
          expect(@user.add_card(@token)).to eq [false, "Stripe error - Your card's security code is incorrect."]
        end
        it "returns false when declined status" do
          @token = "tok_chargeDeclined"
          expect(@user.add_card(@token)).to eq [false, "Stripe error - Your card was declined."]
        end
        it "returns false when declined status insufficient funds" do
          @token = "tok_chargeDeclinedInsufficientFunds"
          expect(@user.add_card(@token)).to eq [false, "Stripe error - Your card has insufficient funds."]
        end
        it "returns false when declined status incorrect cvc" do
          @token = "tok_chargeDeclinedIncorrectCvc"
          expect(@user.add_card(@token)).to eq [false, "Stripe error - Your card's security code is incorrect."]
        end
        it "returns false when declined status expired card" do
          @token = "tok_chargeDeclinedExpiredCard"
          expect(@user.add_card(@token)).to eq [false, "Stripe error - Your card has expired."]
        end
      end
    end
    context "user with invalid cus_id" do
      before do
        @user.stripe_cus_id = "eeeeee"
        @token = "tok_jp"
      end
      it "returns false" do
        expect(@user.add_card(@token)).to eq [false, "Stripe error - No such customer: #{@user.stripe_cus_id}"]
      end
    end
    context "user with blank cus_id" do
      before do
        @user.stripe_cus_id = nil
        @token = "tok_jp"
      end
      it "returns false" do
        expect(@user.add_card(@token)).to eq [false, "stripe_cus_id is blank"]
      end
    end
  end
  
  describe "method::change_default_card" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "card exists in user source" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
        @card_id = test_stripe_card_id_2
      end
      it "returns customer with default source set as card_id" do
        expect(@user.change_default_card(@card_id)[1]["default_source"]).to eq @card_id
      end
      after do
        Stripe::Customer.update(@user.stripe_cus_id,{default_source: test_stripe_card_id_1,})
      end
    end
    context "card does not exist in user source" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
        @card_id = "cccccc"
      end
      it "returns false" do
        expect(@user.change_default_card(@card_id)).to eq [false, "card does not exist with this user"]
      end
    end
    context "no cards exist in user source" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
        @card_id = test_stripe_card_id_2
        allow_any_instance_of(User).to receive(:get_cards).and_return([false, nil])
      end
      it "returns false" do
        expect(@user.change_default_card(@card_id)[0]).to eq false
      end
    end
    context "Stripe returns blank customer data" do
      before do
        @user.stripe_cus_id = test_stripe_cus_id
        @card_id = test_stripe_card_id_2
        allow(Stripe::Customer).to receive(:update).and_return({})
      end
      it "returns false" do
        expect(@user.change_default_card(@card_id)).to eq [false, "customer not present in results"]
      end
    end
  end
  
  describe "method::create_cus_from_card" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "token is blank" do
      it "returns false" do
        expect(@user.create_cus_from_card(nil)).to eq [false, "token is blank"]
      end
    end
    context "token is valid" do
      before do
        @token = "tok_jp"
      end
      it "returns new customer data" do
        @customer = @user.create_cus_from_card(@token)[1]
        expect(@customer["object"]).to eq "customer"
      end
      it "updates customer with stripe_cus_id" do
        @customer = @user.create_cus_from_card(@token)[1]
        expect(@user.stripe_cus_id).to eq @customer["id"]
      end      
      after do
        Stripe::Customer.delete(@customer["id"])
      end
    end
    context "Stripe returns blank customer data" do
      before do
        @token = "tok_jp"
        allow(Stripe::Customer).to receive(:create).and_return({})
      end
      it "returns false" do
        expect(@user.create_cus_from_card(@token)).to eq [false, "customer not present in results"]
      end
    end
  end
  
  describe "method::get_balance" do
    before do
      @user = FactoryBot.create(:user)
    end
    context "Stripe account exists" do
      before do
        @account = FactoryBot.create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it "returns false when get_stripe_balance returns false" do
        allow_any_instance_of(Account).to receive(:get_stripe_balance).and_return([false, "Stripe error"])
        expect(@user.get_balance).to eq [false, "failed to retrieve user's balance info : Stripe error"]
      end
      it "returns false when available balance does not exist" do
        allow_any_instance_of(Account).to receive(:get_stripe_balance).and_return([true, stripe_balance_obj_corrupt])
        expect(@user.get_balance).to eq [false, "failed to retrieve user's available balance"]
      end
      it "returns true and available balance amount" do
        allow_any_instance_of(Account).to receive(:get_stripe_balance).and_return([true, stripe_balance_obj])
        expect(@user.get_balance).to eq [true, stripe_balance_obj["available"][0]["amount"]]
      end
    end
    context "no Stripe account" do
      it "returns false" do
        expect(@user.get_balance).to eq [false, "user's account does not exist"]
      end
    end
  end
  
  describe "method::set_source" do
    before do
      @user = FactoryBot.create(:user, stripe_cus_id: nil)
    end
    context "using new credit card" do
      before do
        @charge_params = { :stripeToken => "tok_jp", :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
      end
      context "for existing customer" do
        before do
          @user.stripe_cus_id = test_stripe_cus_id
        end
        it "returns added card info when success" do
          allow_any_instance_of(User).to receive(:add_card).and_return([true, test_stripe_card])
          expect(@user.set_source(@charge_params)).to eq [true, test_stripe_card]
        end
        it "returns false and message when failed" do
          allow_any_instance_of(User).to receive(:add_card).and_return([false, "some error from add_card"])
          expect(@user.set_source(@charge_params)).to eq [false, "failed to add card : some error from add_card"]
        end
      end
      context "for new customer" do
        it "returns created customer info when success" do
          allow_any_instance_of(User).to receive(:create_cus_from_card).and_return([true, test_stripe_customer])
          expect(@user.set_source(@charge_params)).to eq [true, test_stripe_customer]
        end
        it "returns false and message when failed" do
          allow_any_instance_of(User).to receive(:create_cus_from_card).and_return([false, "some error from create_cus_from_card"])
          expect(@user.set_source(@charge_params)).to eq [false, "failed to set card to customer : some error from create_cus_from_card"]
        end
      end
    end
    context "using existing credit card" do
      context "valid customer and credit card" do
        before do
          @user.stripe_cus_id = test_stripe_cus_id
          @charge_params = { :card_id => test_stripe_card_id_2, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
        end
        it "returns true and customer" do
          expect(@user.set_source(@charge_params)[1]["default_source"]).to eq test_stripe_card_id_2
        end
        after do
        Stripe::Customer.update(@user.stripe_cus_id,{default_source: test_stripe_card_id_1,})
        end
      end
      context "invalid customer" do
        before do
          @charge_params = { :card_id => test_stripe_card_id_2, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
        end
        it "returns false when stripe_cus_id is blank" do
          @user.stripe_cus_id = nil
          expect(@user.set_source(@charge_params)).to eq [false, "stripe_cus_id is blank"]
        end
        it "returns false when stripe_cus_id does not exist" do
          @user.stripe_cus_id = "cccccc"
          expect(@user.set_source(@charge_params)).to eq [false, "failed to change card : failed to get cards : Stripe error - No such customer: cccccc"]
        end
      end
      context "invalid credit card" do
        before do
          @user.stripe_cus_id = test_stripe_cus_id
        end
        it "returns false when card_id is blank" do
          @charge_params = { :card_id => nil, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
          expect(@user.set_source(@charge_params)).to eq [false, "no valid source exists"]
        end
        it "returns false when card_id does not exist" do
          @charge_params = { :card_id => "dddddd", :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
          expect(@user.set_source(@charge_params)).to eq [false, "failed to change card : card does not exist with this user"]
        end
      end
    end
    context "using points" do
      context "account does not exist for the user" do
        before do
          @charge_params = { :user_points => 100, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
        end
        it "returns false" do
          expect(@user.set_source(@charge_params)).to eq [false, "user account does not exist"]
        end
      end
      context "existing account" do
        before do
          @account = FactoryBot.create(:account, user: @user, stripe_acct_id: valid_stripe_acct_id)
        end
        it "returns false when charge amount does not exist" do
          @charge_params = { :user_points => 100, :price => 100, :ctax => 10, :seller_revenue => 99 }
          expect(@user.set_source(@charge_params)).to eq [false, "charge amount does not exist"]
        end
        it "returns false when insufficient points" do
          @charge_params = { :user_points => 100, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
          expect(@user.set_source(@charge_params)).to eq [false, "insufficient points"]
        end
        it "returns false when get_stripe_account returns error" do
          @charge_params = { :user_points => 200, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([false, "some error"])
          expect(@user.set_source(@charge_params)).to eq [false, "failed to get stripe account : some error"]
        end
        it "returns account info" # ExternalAccountの仕様・テストを固めたあと。
        # do
        #   @charge_params = { :user_points => 200, :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
        #   expect(@user.set_source(@charge_params)).to eq [true, "failed to get stripe account : some error"]
        # end
      end
    end
    context "no source in params" do
      before do
        @charge_params = { :price => 100, :ctax => 10, :charge_amount => 110, :seller_revenue => 99 }
      end
      it "returns false" do
        expect(@user.set_source(@charge_params)).to eq [false, "no valid source exists"]
      end
    end
  end
  
  describe "method::get_sold_netas_info" do
    before do
      @topic1 = FactoryBot.create(:topic, :with_user)
      @topic2 = FactoryBot.create(:topic, :with_user)
      @topic3 = FactoryBot.create(:topic, :with_user)
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @user3 = FactoryBot.create(:user)
      @neta1 = FactoryBot.create(:neta, :with_valuetext, user: @user1, topic: @topic1)
      @neta2 = FactoryBot.create(:neta, :with_valuetext, user: @user2, topic: @topic1)
      @neta3 = FactoryBot.create(:neta, :with_valuetext, user: @user1, topic: @topic2)
      @neta4 = FactoryBot.create(:neta, :with_valuetext, user: @user2, topic: @topic2)
      @neta5 = FactoryBot.create(:neta, :with_valuetext, user: @user1, topic: @topic3)
      @neta6 = FactoryBot.create(:neta, :with_valuetext, user: @user2, topic: @topic3)
      @neta7 = FactoryBot.create(:neta, :with_valuetext, user: @user3, topic: @topic3)
    end
    context "when no sold netas exist for user" do
      before do
        @trade1 = FactoryBot.create(:trade, tradeable: @neta6, seller_id: @user2.id, buyer_id: @user1.id)
        @trade2 = FactoryBot.create(:trade, tradeable: @neta7, seller_id: @user3.id, buyer_id: @user2.id)
      end
      it "returns false" do
        expect(@user1.get_sold_netas_info).to eq [false, "No sold netas found for user_id #{@user1.id}"]
      end
    end
    context "when sold netas exist for user" do
      before do
        @trade1 = FactoryBot.create(:trade, tradeable: @neta3, seller_id: @user1.id, buyer_id: @user3.id)
        @trade2 = FactoryBot.create(:trade, tradeable: @neta5, seller_id: @user1.id, buyer_id: @user2.id)
        @trade3 = FactoryBot.create(:trade, tradeable: @neta6, seller_id: @user2.id, buyer_id: @user1.id)
        @trade4 = FactoryBot.create(:trade, tradeable: @neta7, seller_id: @user3.id, buyer_id: @user2.id)
      end
      it "returns sold netas" do
        sold_netas_info = [
                            {"traded_at" => @trade1.created_at, "text" => @neta3.text.truncate(10), "price" => @trade1.price, "buyer_id" => @user3.id, "buyer_nickname" => @user3.nickname, "review_rate" => nil},
                            {"traded_at" => @trade2.created_at, "text" => @neta5.text.truncate(10), "price" => @trade2.price, "buyer_id" => @user2.id, "buyer_nickname" => @user2.nickname, "review_rate" => nil}
                          ]
        expect(@user1.get_sold_netas_info).to eq [true, sold_netas_info]
      end
    end
    
  end
end
