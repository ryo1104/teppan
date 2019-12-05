require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user_create)           { FactoryBot.create(:user) }
  let(:test_stripe_acct_id)   { "acct_1FHvBMCx2rPekxgm" }
  let(:stripe_account_obj)    {
    {
     "id"=>"acct_1FHvBMCx2rPekxgm",
     "object"=>"account",
     "business_profile"=>
      {"mcc"=>nil,
       "name"=>nil,
       "product_description"=>nil,
       "support_address"=>nil,
       "support_email"=>nil,
       "support_phone"=>nil,
       "support_url"=>nil,
       "url"=>nil},
     "business_type"=>"individual",
     "capabilities"=>{"legacy_payments"=>"active"},
     "charges_enabled"=>false,
     "country"=>"JP",
     "created"=>1556620983,
     "default_currency"=>"jpy",
     "details_submitted"=>true,
     "email"=>nil,
     "external_accounts"=>
      {"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/accounts/acct_1EUtQQBImRhqCMSQ/external_accounts"},
     "individual"=>
      {"id"=>"person_Eyr8PiG0EsvSra",
       "object"=>"person",
       "account"=>"acct_1EUtQQBImRhqCMSQ",
       "address_kana"=>
        {"city"=>"ﾁﾖﾀﾞｸ",
         "country"=>"JP",
         "line1"=>"15-2-201",
         "line2"=>"ｵｵﾔﾏﾋﾞﾙ",
         "postal_code"=>"1010021",
         "state"=>"ﾄｳｷﾖｳﾄ",
         "town"=>"ｿﾄｶﾝﾀﾞ 2-"},
       "address_kanji"=>
        {"city"=>"千代田区", "country"=>"JP", "line1"=>"１５−２−２０１", "line2"=>"大山ビル", "postal_code"=>"１０１００２１", "state"=>"東京都", "town"=>"外神田２丁目"},
       "created"=>1556620982,
       "dob"=>{"day"=>24, "month"=>5, "year"=>1977},
       "email"=>"kenske@hoge.com",
       "first_name"=>"賢介",
       "first_name_kana"=>"ケンスケ",
       "first_name_kanji"=>"賢介",
       "gender"=>"male",
       "last_name"=>"山田",
       "last_name_kana"=>"ヤマダ",
       "last_name_kanji"=>"山田",
       "metadata"=>{},
       "phone"=>"+81376332219",
       "relationship"=>
        {"account_opener"=>true, "director"=>false, "executive"=>false, "owner"=>false, "percent_ownership"=>nil, "title"=>nil},
       "requirements"=>{"currently_due"=>[], "eventually_due"=>["verification.document"], "past_due"=>[], "pending_verification"=>[]},
       "verification"=>
        {"details"=>"Provided identity information could not be verified",
         "details_code"=>"failed_keyed_identity",
         "document"=>{"back"=>nil, "details"=>"Scan failed", "details_code"=>nil, "front"=>nil},
         "status"=>"unverified"}},
       "metadata"=>{},
       "payouts_enabled"=>false,
       "requirements"=>
        {"current_deadline"=>nil,
         "currently_due"=>[],
         "disabled_reason"=>"rejected.other",
         "eventually_due"=>[],
         "past_due"=>[],
         "pending_verification"=>[]},
       "settings"=>
        {"branding"=>{"icon"=>nil, "logo"=>nil, "primary_color"=>nil},
         "card_payments"=>{"decline_on"=>{"avs_failure"=>false, "cvc_failure"=>false}, "statement_descriptor_prefix"=>nil},
         "dashboard"=>{"display_name"=>nil, "timezone"=>"Etc/UTC"},
         "payments"=>{"statement_descriptor"=>"", "statement_descriptor_kana"=>nil, "statement_descriptor_kanji"=>nil},
         "payouts"=>
          {"debit_negative_balances"=>false,
           "schedule"=>{"delay_days"=>4, "interval"=>"weekly", "weekly_anchor"=>"friday"},
           "statement_descriptor"=>nil}},
       "tos_acceptance"=>{"date"=>1566575169, "ip"=>"202.32.34.208", "user_agent"=>nil},
       "type"=>"custom"
      }
    }
  let(:account_info_hash)     { 
                                { "id"=>"acct_1FHvBMCx2rPekxgm",
                                  "personal_info"=>{
                                    "last_name_kanji"=>"山田",
                                    "last_name_kana"=>"ヤマダ",
                                    "first_name_kanji"=>"賢介",
                                    "first_name_kana"=>"ケンスケ",
                                    "gender"=>"男性",
                                    "email"=>"kenske@hoge.com",
                                    "dob"=>{"year"=>1977, "month"=>5, "day"=>24},
                                    "postal_code"=>"1010021",
                                    "kanji_state"=>"東京都",
                                    "kanji_city"=>"千代田区",
                                    "kanji_town"=>"外神田２丁目",
                                    "kanji_line1"=>"１５−２−２０１",
                                    "kanji_line2"=>"大山ビル",
                                    "kana_state"=>"ﾄｳｷﾖｳﾄ",
                                    "kana_city"=>"ﾁﾖﾀﾞｸ",
                                    "kana_town"=>"ｿﾄｶﾝﾀﾞ 2-",
                                    "kana_line1"=>"15-2-201",
                                    "kana_line2"=>"ｵｵﾔﾏﾋﾞﾙ",
                                    "phone"=>"+81376332219",
                                    "verification"=>{
                                      "details"=>"Provided identity information could not be verified",
                                      "details_code"=>"failed_keyed_identity",
                                      "document"=>{"back"=>nil, "details"=>"Scan failed", "details_code"=>nil, "front"=>nil},
                                      "status"=>"unverified"
                                    }
                                  },
                                  "tos_acceptance"=>{"date"=>1566575169, "ip"=>"202.32.34.208", "user_agent"=>nil},
                                  "bank_info"=>{"bank_name"=>nil, "branch_name"=>nil, "account_number"=>nil, "account_holder_name"=>nil},
                                  "payouts_enabled"=>false,
                                  "requirements"=>
                                   {"current_deadline"=>nil, "currently_due"=>[], "disabled_reason"=>"rejected.other", "eventually_due"=>[], "past_due"=>[]}
                                }
                              }
  let(:filled_personal_info)  {
                                {
                                  "last_name_kanji"=>"山田",
                                  "last_name_kana"=>"ヤマダ",
                                  "first_name_kanji"=>"賢介",
                                  "first_name_kana"=>"ケンスケ",
                                  "gender"=>"男性",
                                  "email"=>"kenske@hoge.com",
                                  "dob"=>{"year"=>1977, "month"=>5, "day"=>24},
                                  "postal_code"=>"1010021",
                                  "kanji_state"=>"東京都",
                                  "kanji_city"=>"千代田区",
                                  "kanji_town"=>"外神田２丁目",
                                  "kanji_line1"=>"１５−２−２０１",
                                  "kanji_line2"=>"大山ビル",
                                  "kana_state"=>"ﾄｳｷﾖｳﾄ",
                                  "kana_city"=>"ﾁﾖﾀﾞｸ",
                                  "kana_town"=>"ｿﾄｶﾝﾀﾞ 2-",
                                  "kana_line1"=>"15-2-201",
                                  "kana_line2"=>"ｵｵﾔﾏﾋﾞﾙ",
                                  "phone"=>"+81376332219",
                                  "verification"=>
                                     {"details"=>"Provided identity information could not be verified",
                                      "details_code"=>"failed_keyed_identity",
                                      "document"=>{"back"=>nil, "details"=>"Scan failed", "details_code"=>nil, "front"=>nil},
                                      "status"=>"unverified"},
                                 }
                              }
  let(:blank_stripe_account_obj)  {
    {
      "id"=>"acct_1EfsQ9DbspCWjyde", 
      "object"=>"account", 
      "business_profile"=>{"mcc"=>nil, "name"=>nil, "product_description"=>nil, "support_address"=>nil, "support_email"=>nil, "support_phone"=>nil, "support_url"=>nil, "url"=>nil}, 
      "business_type"=>"individual", 
      "capabilities"=>{"legacy_payments"=>"active"}, 
      "charges_enabled"=>false, 
      "country"=>"JP", 
      "created"=>1559238730, 
      "default_currency"=>"jpy", 
      "details_submitted"=>false, 
      "email"=>nil, 
      "external_accounts"=>{"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/accounts/acct_1EfsQ9DbspCWjyde/external_accounts"}, 
      "individual"=>
        {
          "id"=>"person_FACppgeqFMxBQW", 
          "object"=>"person", 
          "account"=>"acct_1EfsQ9DbspCWjyde", 
          "address_kana"=>{"city"=>nil, "country"=>"JP", "line1"=>nil, "line2"=>nil, "postal_code"=>nil, "state"=>nil, "town"=>nil},
          "address_kanji"=>{"city"=>nil, "country"=>"JP", "line1"=>nil, "line2"=>nil, "postal_code"=>nil, "state"=>nil, "town"=>nil}, 
          "created"=>1559238730, 
          "dob"=>{"day"=>nil, "month"=>nil, "year"=>nil}, 
          "email"=>"shunpei@hogehoge.com", 
          "first_name_kana"=>nil, 
          "first_name_kanji"=>nil, 
          "gender"=>"male", 
          "last_name_kana"=>nil, 
          "last_name_kanji"=>nil, 
          "metadata"=>{}, 
          "relationship"=>{"account_opener"=>true, "director"=>false, "executive"=>false, "owner"=>false, "percent_ownership"=>nil, "title"=>nil}, 
          "requirements"=>{"currently_due"=>["dob.day", "dob.month", "dob.year", "first_name_kana", "first_name_kanji", "last_name_kana", "last_name_kanji"], 
                           "eventually_due"=>["dob.day", "dob.month", "dob.year", "first_name_kana", "first_name_kanji", "last_name_kana", "last_name_kanji"], 
                           "past_due"=>["dob.day", "dob.month", "dob.year", "first_name_kana", "first_name_kanji", "last_name_kana", "last_name_kanji"], 
                           "pending_verification"=>[]}, 
          "verification"=>{"details"=>nil, "details_code"=>nil, "document"=>{"back"=>nil, "details"=>nil, "details_code"=>nil, "front"=>nil}, "status"=>"unverified"}
        }, 
      "metadata"=>{}, 
      "payouts_enabled"=>false, 
      "requirements"=>
        {
          "current_deadline"=>nil, 
          "currently_due"=>["external_account", "individual.address_kana.line1", "individual.address_kanji.line1", "individual.dob.day", "individual.dob.month", "individual.dob.year", "individual.first_name_kana", "individual.first_name_kanji", "individual.last_name_kana", "individual.last_name_kanji", "individual.phone", "tos_acceptance.date", "tos_acceptance.ip"], 
          "disabled_reason"=>"requirements.past_due", 
          "eventually_due"=>["external_account", "individual.address_kana.line1", "individual.address_kanji.line1", "individual.dob.day", "individual.dob.month", "individual.dob.year", "individual.first_name_kana", "individual.first_name_kanji", "individual.last_name_kana", "individual.last_name_kanji", "individual.phone", "tos_acceptance.date", "tos_acceptance.ip"], 
          "past_due"=>["individual.address_kana.line1", "individual.address_kanji.line1", "individual.dob.day", "individual.dob.month", "individual.dob.year", "individual.first_name_kana", "individual.first_name_kanji", "individual.last_name_kana", "individual.last_name_kanji", "individual.phone"], 
          "pending_verification"=>[]
        }, 
      "settings"=>
        {
          "branding"=>{"icon"=>nil, "logo"=>nil, "primary_color"=>nil}, 
          "card_payments"=>{"decline_on"=>{"avs_failure"=>false, "cvc_failure"=>false}, 
          "statement_descriptor_prefix"=>nil}, 
          "dashboard"=>{"display_name"=>nil, "timezone"=>"Etc/UTC"}, 
          "payments"=>{"statement_descriptor"=>"", "statement_descriptor_kana"=>nil, "statement_descriptor_kanji"=>nil}, 
          "payouts"=>{"debit_negative_balances"=>false, "schedule"=>{"delay_days"=>4, "interval"=>"weekly", "weekly_anchor"=>"friday"}, "statement_descriptor"=>nil}}, 
          "tos_acceptance"=>{"date"=>nil, "ip"=>nil, "user_agent"=>nil}, 
          "type"=>"custom"
        }
    }
  let(:blank_personal_info)   {
    {
      "last_name_kanji"=>nil, 
      "last_name_kana"=>nil, 
      "first_name_kanji"=>nil, 
      "first_name_kana"=>nil, 
      "gender"=>"男性", 
      "email"=>"shunpei@hogehoge.com", 
      "dob"=>{"year"=>nil, "month"=>nil, "day"=>nil}, 
      "postal_code"=>nil, 
      "kanji_state"=>nil, 
      "kanji_city"=>nil, 
      "kanji_town"=>nil, 
      "kanji_line1"=>nil, 
      "kanji_line2"=>nil, 
      "kana_state"=>nil, 
      "kana_city"=>nil, 
      "kana_town"=>nil, 
      "kana_line1"=>nil, 
      "kana_line2"=>nil, 
      "verification"=>
        {
          "details"=>nil, 
          "details_code"=>nil, 
          "document"=>{"back"=>nil, "details"=>nil, "details_code"=>nil, "front"=>nil}, 
          "status"=>"unverified"
        }
    }}
  let(:new_acct_params)     { 
                              { :business_type=>"individual", 
                                :individual=>{:last_name=>"山田", :last_name_kanji=>"山田", :last_name_kana=>"ヤマダ", 
                                             :first_name=>"賢介", :first_name_kanji=>"賢介", :first_name_kana=>"ケンスケ", 
                                             :gender=>"male", 
                                             :dob=>{:year=>"1977", :month=>"5", :day=>"24"}, 
                                             :address_kanji=>{:postal_code=>"1010021", :state=>"東京都", :city=>"千代田区", 
                                                              :town=>"外神田３丁目", :line1=>"１５−２−２０１", :line2=>"大山ビル"}, 
                                             :address_kana=>{:line1=>"15-2-201", :line2=>"オオヤマビル"}, 
                                             :phone=>"+81 3 7633 2219", 
                                             :email=>"kenske@hoge.com"
                                             }, 
                                :tos_acceptance=>{:date=>1566575169, :ip=>"202.32.34.208"}, 
                                :type=>"custom", 
                                :country=>"JP"
                              }
                            }
  let(:update_acct_params)  { 
                              { :business_type=>"individual", 
                                :individual=>{:last_name=>"山田", :last_name_kanji=>"山田", :last_name_kana=>"ヤマダ", 
                                             :first_name=>"賢介", :first_name_kanji=>"賢介", :first_name_kana=>"ケンスケ", 
                                             :gender=>"male", 
                                             :dob=>{:year=>"1977", :month=>"5", :day=>"24"}, 
                                             :address_kanji=>{:postal_code=>"1010021", :state=>"東京都", :city=>"千代田区", 
                                                              :town=>"外神田３丁目", :line1=>"１５−２−２０１", :line2=>"大山ビル"}, 
                                             :address_kana=>{:line1=>"15-2-201", :line2=>"オオヤマビル"}, 
                                             :phone=>"+81 3 7633 2219", 
                                             :email=>"kenske@hoge.com"
                                             }, 
                                :tos_acceptance=>{:date=>1566575169, :ip=>"202.32.34.208"}
                              }
                            }
  let(:created_acct_info_hash) {
                                  {
                                  "id"=>nil,
                                  "personal_info"=>{
                                    "last_name_kanji"=>"山田",
                                    "last_name_kana"=>"ヤマダ",
                                    "first_name_kanji"=>"賢介",
                                    "first_name_kana"=>"ケンスケ",
                                    "gender"=>"男性",
                                    "email"=>"kenske@hoge.com",
                                    "dob"=>{"year"=>1977, "month"=>5, "day"=>24},
                                    "postal_code"=>"1010021",
                                    "kanji_state"=>"東京都",
                                    "kanji_city"=>"千代田区",
                                    "kanji_town"=>"外神田３丁目",
                                    "kanji_line1"=>"１５−２−２０１",
                                    "kanji_line2"=>"大山ビル",
                                    "kana_state"=>"ﾄｳｷﾖｳﾄ",
                                    "kana_city"=>"ﾁﾖﾀﾞｸ",
                                    "kana_town"=>"ｿﾄｶﾝﾀﾞ 3-",
                                    "kana_line1"=>"15-2-201",
                                    "kana_line2"=>"ｵｵﾔﾏﾋﾞﾙ",
                                    "phone"=>"+81376332219",
                                    "verification"=>{
                                      "details"=>nil,
                                       "details_code"=>nil,
                                       "document"=>{"back"=>nil, "details"=>nil, "details_code"=>nil, "front"=>nil},
                                       "status"=>"pending"
                                      }
                                    },
                                  "tos_acceptance"=>{"date"=>1566575782, "ip"=>"202.32.34.208", "user_agent"=>nil},
                                  "bank_info"=>{"bank_name"=>nil, "branch_name"=>nil, "account_number"=>nil, "account_holder_name"=>nil},
                                  "payouts_enabled"=>false,
                                  "requirements"=>{
                                    "current_deadline"=>nil,
                                    "currently_due"=>["external_account"],
                                    "disabled_reason"=>nil,
                                    "eventually_due"=>["external_account"],
                                    "past_due"=>["external_account"]
                                  }
                                }
                              }
  let(:stripe_balance_obj) { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}],
                                  "livemode"=>false,
                                  "pending"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}]
                                }
                              }
  let(:zero_balance_obj) { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}],
                                  "livemode"=>false,
                                  "pending"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}]
                                }
                              }
  let(:available_bal_remain) { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{"amount"=>1, "currency"=>"jpy", "source_types"=>{"card"=>0}}],
                                  "livemode"=>false,
                                  "pending"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}]
                                }
                              }
  let(:pending_bal_remain) { 
                                { 
                                  "object"=>"balance",
                                  "available"=>[{"amount"=>0, "currency"=>"jpy", "source_types"=>{"card"=>0}}],
                                  "livemode"=>false,
                                  "pending"=>[{"amount"=>1, "currency"=>"jpy", "source_types"=>{"card"=>0}}]
                                }
                              }
  let(:blank_bank_info) { 
    {"bank_name"=>nil, "branch_name"=>nil, "account_number"=>nil, "account_holder_name"=>nil} }
  
  describe "Validations" do
    it "is valid with a user_id" do
      account = build(:account, user: user_create)
      expect(account).to be_valid
    end
    
    it "is invalid without a user" do
      account = build(:account, user: nil)
      account.valid?
      expect(account.errors[:user]).to include("を入力してください")
    end
    
    it "is invalid if stripe_acct_id does not start with acct_" do
      account = build(:account, user: user_create, stripe_acct_id: "aaaa_"+Faker::Lorem.characters(number: 16))
      account.valid?
      expect(account.errors[:stripe_acct_id]).to include("stripe_acct_id does not start with acct_")
    end

    it "is invalid with a duplicate stripe_acct_id" do
      some_user = create(:user)
      create(:account, user: some_user, stripe_acct_id: "acct_abcdeFGHIJ123456")
      another_user = create(:user)
      account = build(:account, user: another_user, stripe_acct_id: "acct_abcdeFGHIJ123456")
      account.valid?
      expect(account.errors[:stripe_acct_id]).to include("はすでに存在します。")
    end
  end
  
  describe "method::get_stripe_account" do
    it "retrieves account details" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      result = account.get_stripe_account
      # 内容が都度変化するものはそのまま結果からコピー
      account_info_hash["personal_info"].merge!({"verification" => result[1]["personal_info"]["verification"]})
      account_info_hash.merge!({"requirements" => result[1]["requirements"]})
      account_info_hash.merge!({"tos_acceptance" => result[1]["tos_acceptance"]})
      
      expect(result).to match [true, account_info_hash]
    end
        
    it "returns false with blank stripe_acct_id" do
      account = create(:account, stripe_acct_id: nil)
      result = account.get_stripe_account
      expect(result).to match [false, "stripe_acct_id is blank"]
    end
    it "raises exception with invalid stripe_acct_id" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id+"aaa")
      expect(account.get_stripe_account[1]).to include("Stripe error")
    end
  end

  describe "method::get_stripe_balance" do
    it "retrieves balance details as hash" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      expect(account.get_stripe_balance).to eq [true, stripe_balance_obj]
    end
    it "returns false with blank stripe_acct_id" do
      account = create(:account, stripe_acct_id: nil)
      expect(account.get_stripe_balance).to eq [false, "stripe_acct_id is blank"]
    end
    it "raises exception with invalid stripe_acct_id" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id+"aaa")
      expect(account.get_stripe_balance[0]).to eq false
    end
    it "returns false when check_stripe_results returns false" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      allow(Stripe::Balance).to receive(:retrieve).and_return(true)
      allow(JSON).to receive(:parse).and_return(true)
      allow(Account).to receive(:check_stripe_results).and_return([false, "error message from check_stripe_results"])
      expect(account.get_stripe_balance).to eq [false, "error message from check_stripe_results"]
    end    
  end
  
  describe "method::zero_balance" do
    it "returns false when get_stripe_balance returns false" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      allow(account).to receive(:get_stripe_balance).and_return([false, ""])
      result = account.zero_balance
      expect(result).to eq false
    end
    it "returns false when available balance is not zero" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      allow(account).to receive(:get_stripe_balance).and_return([true, available_bal_remain])
      result = account.zero_balance
      expect(result).to eq false
    end
    it "returns false when pending balance is not zero" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      allow(account).to receive(:get_stripe_balance).and_return([true, pending_bal_remain])
      result = account.zero_balance
      expect(result).to eq false
    end
    it "returns true when available balance and pending balance are both zero" do
      account = create(:account, stripe_acct_id: test_stripe_acct_id)
      allow(account).to receive(:get_stripe_balance).and_return([true, zero_balance_obj])
      result = account.zero_balance
      expect(result).to eq true
    end
  end
  
  describe "method::create_stripe_account" do
    context "is unsuccessful and" do
      it "returns false when check_stripe_inputs returns false" do
        allow(Account).to receive(:check_stripe_inputs).and_return([false, "error message from check_stripe_inputs"])
        expect(Account.create_stripe_account(new_acct_params)).to match [false, "error message from check_stripe_inputs"]
      end
      it "returns false with invalid inputs" do
        acct_params = new_acct_params
        acct_params.merge!({:some_input => "some unnecessary input"})
        allow(Account).to receive(:check_stripe_inputs).and_return([true, nil])
        expect(Account.create_stripe_account(acct_params)[1]).to include("Stripe error")
      end
      it "returns false when parse_account_info returns false" do
        allow(Stripe::Account).to receive(:create).and_return(true)
        allow(JSON).to receive(:parse).and_return(true)
        allow(Account).to receive(:parse_account_info).and_return([false, "error message from parse_account_info"])
        expect(Account.create_stripe_account(new_acct_params)).to match [false, "error message from parse_account_info"]
      end
    end
    context "successfully" do
      it "creates Stripe account from params" do
        acct_params = new_acct_params
        email = "kenske"+Faker::Lorem.characters(number: 3)+"@hoge.com"
        acct_params[:individual][:email] = email
          
        @result = Account.create_stripe_account(acct_params)
        
        expected_hash = created_acct_info_hash
        expected_hash["personal_info"]["email"] = email
        # 内容が都度変化するものはそのまま結果からコピー
        expected_hash["id"] = @result[1]["id"]
        expected_hash["personal_info"].merge!({"verification" => @result[1]["personal_info"]["verification"]})
        expected_hash.merge!({"tos_acceptance" => @result[1]["tos_acceptance"]})
        expected_hash.merge!({"requirements" => @result[1]["requirements"]})
  
        expect(@result).to match [true, expected_hash]
      end
      after do
        if @result[0]
          JSON.parse(Stripe::Account.delete(@result[1]["id"]).to_s)
        end
      end
    end
  end
  
  describe "method::update_stripe_account" do
    context "is unsuccessful and" do
      it "returns false when stripe_acct_id is blank" do
        account = create(:account, stripe_acct_id: nil)
        expect(account.update_stripe_account(new_acct_params)).to match [false, "stripe_acct_id is blank"]
      end
      it "returns false when check_stripe_inputs returns false" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id)
        allow(Account).to receive(:check_stripe_inputs).and_return([false, "error message from check_stripe_inputs"])
        expect(account.update_stripe_account(new_acct_params)).to match [false, "error message from check_stripe_inputs"]
      end
      it "returns false when stripe_acct_id is invalid" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id+"aaa")
        allow(Account).to receive(:check_stripe_inputs).and_return([true, nil])
        expect(account.update_stripe_account(new_acct_params)[1]).to include("Stripe error")
      end
      it "returns false when parse_account_info returns false" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id)
        allow(Stripe::Account).to receive(:update).and_return(true)
        allow(JSON).to receive(:parse).and_return(true)
        allow(Account).to receive(:parse_account_info).and_return([false, "error message from parse_account_info"])
        expect(account.update_stripe_account(new_acct_params)).to match [false, "error message from parse_account_info"]
      end
    end
    context "successfully" do
      before do
        @create_result = JSON.parse(Stripe::Account.create(new_acct_params).to_s)
        @account = create(:account, stripe_acct_id: @create_result["id"])
      end
      it "updates Stripe account from params" do
        update_params = update_acct_params
        update_params[:individual][:address_kanji][:town] = "外神田２丁目"
        
        expected_result = created_acct_info_hash
        expected_result["id"] = @account.stripe_acct_id
        expected_result["personal_info"]["kanji_town"] = "外神田２丁目"
        expected_result["personal_info"]["kana_town"] = "ｿﾄｶﾝﾀﾞ 2-"
        
        result = @account.update_stripe_account(update_params)
  
        # 内容が都度変化するものはそのまま結果からコピー
        expected_result["personal_info"].merge!({"verification" => result[1]["personal_info"]["verification"]})
        expected_result.merge!({"tos_acceptance" => result[1]["tos_acceptance"]})
        expected_result.merge!({"requirements" => result[1]["requirements"]})
        
        expect(result).to match [true, expected_result]
      end
      after do
        JSON.parse(Stripe::Account.delete(@account.stripe_acct_id).to_s)
      end
    end
  end
  
  describe "method::delete_stripe_account" do
    context "is unsuccessful and" do
      it "returns false with blank stripe_acct_id" do
        account = create(:account, stripe_acct_id: nil)
        expect(account.delete_stripe_account).to match [false, "stripe_acct_id is blank"]
      end
      it "returns false with balance remaining on account" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id)
        allow(account).to receive(:zero_balance).and_return(false)
        expect(account.delete_stripe_account).to match [false, "balance still remains on the account"]
      end
      it "returns false with invalid stripe_acct_id" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id+"aaa")
        allow(account).to receive(:zero_balance).and_return(true)
        expect(account.delete_stripe_account[1]).to include("Stripe error")
      end
      it "returns false when Stripe does not return deleted as true" do
        account = create(:account, stripe_acct_id: test_stripe_acct_id)
        allow(account).to receive(:zero_balance).and_return(true)
        allow(Stripe::Account).to receive(:delete).and_return(true)
        allow(JSON).to receive(:parse).and_return({"id" => nil, "object" => "account", "deleted" => false})
        expect(account.delete_stripe_account).to match [false, "account was not deleted for some reason"]
      end
    end
    context "successfully" do
      before do
        @create_result = JSON.parse(Stripe::Account.create(new_acct_params).to_s)
        @account = create(:account, stripe_acct_id: @create_result["id"])
      end
      it "deletes Stripe account and returns true" do
        @result = @account.delete_stripe_account
        expect(@result).to match [true, {"account" => {"id" => @account.stripe_acct_id, "object" => "account", "deleted" => true}}]
      end
      after do
        if @result[0] == false
          JSON.parse(Stripe::Account.delete(@account.stripe_acct_id).to_s)
        end
      end
    end
  end
  
  describe "method::check_stripe_inputs(account_params, action)" do
    before do
      @account_params = new_acct_params
    end
    context "for any action" do
      it "returns false when action is not update or create" do
        result = Account.check_stripe_inputs(@account_params, "show")
        expect(result).to match [false, "invalid input : action is show"]
      end
    end
    context "for update action" do
      it "returns false when :business_type does not exist" do
        @account_params.delete(:business_type)
        result = Account.check_stripe_inputs(@account_params, "update")
        expect(result).to match [false, "params for :business_type does not exist"]
      end
      it "returns false when :business_type is not set to individual" do
        @account_params[:business_type] = "company"
        result = Account.check_stripe_inputs(@account_params, "update")
        expect(result).to match [false, "invalid business type : #{@account_params[:business_type]}"]
      end
      it "returns false when :individual does not exist" do
        @account_params.delete(:individual)
        result = Account.check_stripe_inputs(@account_params, "update")
        expect(result).to match [false, "params for :individual does not exist"]
      end
      it "returns true otherwise" do
        result = Account.check_stripe_inputs(@account_params, "update")
        expect(result).to match [true, nil]
      end
    end
    context "for create action" do
      it "returns false when :business_type does not exist" do
        @account_params.delete(:business_type)
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :business_type does not exist"]
      end
      it "returns false when :business_type is not set to individual" do
        @account_params[:business_type] = "company"
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "invalid business type : #{@account_params[:business_type]}"]
      end
      it "returns false when :individual does not exist" do
        @account_params.delete(:individual)
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :individual does not exist"]
      end
      it "returns false when :type does not exist" do
        @account_params.delete(:business_type)
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :business_type does not exist"]
      end
      it "returns false when :type is not set to custom" do
        @account_params[:type] = "standard"
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "invalid connected account type : standard"]
      end
      it "returns false when :country does not exist" do
        @account_params.delete(:country)
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :country does not exist"]
      end
      it "returns false when :country is not set to JP" do
        @account_params[:country] = "US"
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "invalid country : US"]
      end
      it "returns false when :email does not exist" do
        @account_params[:individual].delete(:email)
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :email does not exist"]
      end
      it "returns false when :email is nil" do
        @account_params[:individual][:email] = nil
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [false, "params for :email is blank"]
      end
      it "returns true otherwise" do
        result = Account.check_stripe_inputs(@account_params, "create")
        expect(result).to match [true, nil]
      end
    end
  end
  
  describe "method::check_stripe_results(stripe_results)" do
    before do
      @stripe_acct_obj = stripe_account_obj
      @stripe_bal_obj = stripe_balance_obj
    end
    context "for account object type" do
      it "returns false when :object does not exist" do
        @stripe_acct_obj.delete("object")
        result = Account.check_stripe_results(@stripe_acct_obj)
        expect(result).to match [false, "params for :object does not exist"]
      end
      it "returns false when :id does not exist" do
        @stripe_acct_obj.delete("id")
        result = Account.check_stripe_results(@stripe_acct_obj)
        expect(result).to match [false, "stripe id does not exist"]
      end
      it "returns false when :individual does not exist" do
        @stripe_acct_obj.delete("individual")
        result = Account.check_stripe_results(@stripe_acct_obj)
        expect(result).to match [false, "params for :individual does not exist"]
      end
      it "returns true otherwise" do
        result = Account.check_stripe_results(@stripe_acct_obj)
        expect(result).to match [true, nil]
      end
    end
    context "for balance object type" do
      it "returns false when :object does not exist" do
        @stripe_bal_obj.delete("object")
        result = Account.check_stripe_results(@stripe_bal_obj)
        expect(result).to match [false, "params for :object does not exist"]
      end
      it "returns false when :available does not exist" do
        @stripe_bal_obj.delete("available")
        result = Account.check_stripe_results(@stripe_bal_obj)
        expect(result).to match [false, "params for :available does not exist"]
      end
      it "returns false when :pending does not exist" do
        @stripe_bal_obj.delete("pending")
        result = Account.check_stripe_results(@stripe_bal_obj)
        expect(result).to match [false, "params for :pending does not exist"]
      end
      it "returns true otherwise" do
        result = Account.check_stripe_results(@stripe_bal_obj)
        expect(result).to match [true, nil]
      end
    end
    context "for other object types" do
      it "returns false" do
        @stripe_acct_obj["object"] = "other_object"
        result = Account.check_stripe_results(@stripe_acct_obj)
        expect(result).to match [false, "unknown stripe object type"]
      end
    end
  end
  
  describe "method::parse_personal_info(individual)" do
    context "blank object" do
      before do
        @stripe_account_obj = blank_stripe_account_obj
        @individual = @stripe_account_obj["individual"]
      end
      it "returns blank personal information" do
        result = Account.parse_personal_info(@individual)
        expect(result).to match [true, blank_personal_info]
      end
    end
    context "filled object" do
      before do
        @stripe_account_obj = stripe_account_obj
        @individual = @stripe_account_obj["individual"]
        @filled_personal_info = filled_personal_info
      end
      it "returns filled personal information" do
        result = Account.parse_personal_info(@individual)
        expect(result).to match [true, @filled_personal_info]
      end
      it "returns 男性 if :gender is male" do
        @individual["gender"] = "male"
        result = Account.parse_personal_info(@individual)
        expect(result[1]["gender"]).to eq '男性'
      end
      it "returns 女性 if :gender is female" do
        @individual["gender"] = "female"
        result = Account.parse_personal_info(@individual)
        expect(result[1]["gender"]).to eq '女性'
      end
    end
  end
  
  describe "method::parse_account_info(stripe_account_hash)" do
    before do
      @stripe_account_obj = stripe_account_obj
    end
    it "returns false when :check_stripe_results is false" do
      allow(Account).to receive(:check_stripe_results).and_return([false, "some message from check_stripe_results"])
      allow(Account).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Externalaccount).to receive(:parse_bank_info).and_return([true, nil])
      
      result = Account.parse_account_info(@stripe_account_obj)
      expect(result).to match [false, "some message from check_stripe_results"]
    end
    it "returns false when :personal_info is false" do
      allow(Account).to receive(:check_stripe_results).and_return([true, nil])
      allow(Account).to receive(:parse_personal_info).and_return([false, "some message from parse_personal_info"])
      allow(Externalaccount).to receive(:parse_bank_info).and_return([true, nil])
      
      result = Account.parse_account_info(@stripe_account_obj)
      expect(result).to match [false, "some message from parse_personal_info"]
    end
    it "returns blank bank info when :parse_bank_info is false" do
      allow(Account).to receive(:check_stripe_results).and_return([true, nil])
      allow(Account).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Externalaccount).to receive(:parse_bank_info).and_return([false, "some message from parse_bank_info"])
      expected_hash = account_info_hash
      expected_hash["bank_info"] = {"bank_name"=>nil, "branch_name"=>nil, "account_number"=>nil, "account_holder_name"=>nil}
      
      result = Account.parse_account_info(@stripe_account_obj)
      # 内容が都度変化するものはそのまま結果からコピー
      expected_hash.merge!({"requirements" => result[1]["requirements"]})
      expect(result).to match [true, expected_hash]
    end
    it "returns account information" do
      allow(Account).to receive(:check_stripe_results).and_return([true, nil])
      allow(Account).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Externalaccount).to receive(:parse_bank_info).and_return([true, blank_bank_info])
      expected_hash = account_info_hash
      expected_hash[""]
      
      result = Account.parse_account_info(@stripe_account_obj)
      # 内容が都度変化するものはそのまま結果からコピー
      expected_hash.merge!({"requirements" => result[1]["requirements"]})
      expect(result).to match [true, expected_hash]
    end
  end
end
