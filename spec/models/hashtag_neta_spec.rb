require 'rails_helper'

RSpec.describe HashtagNeta, type: :model do
  let(:topic)     { FactoryBot.create(:topic, :with_user) }
  let(:neta)      { FactoryBot.create(:neta, :with_user, topic: topic) }
  let(:hashtag)   { FactoryBot.create(:hashtag) }

  describe "Validations" do
    
    it "is valid with a neta_id and hashtag_id" do
      hashtag_neta = HashtagNeta.new( neta: neta, hashtag: hashtag )
      expect(hashtag_neta).to be_valid
    end
    
    it "is invalid without a neta_id" do
      hashtag_neta = HashtagNeta.new( neta: nil, hashtag: hashtag )
      hashtag_neta.valid?
      expect(hashtag_neta.errors[:neta_id]).to include("を入力してください。")
    end
    
    it "is invalid without a hashtag_id" do
      hashtag_neta = HashtagNeta.new( neta: neta, hashtag: nil )
      hashtag_neta.valid?
      expect(hashtag_neta.errors[:hashtag_id]).to include("を入力してください。")
    end
  
    it "is invalid with a duplicate neta_id and hashtag_id combination" do
      HashtagNeta.create( neta: neta, hashtag: hashtag )
      hashtag_neta = HashtagNeta.new( neta: neta, hashtag: hashtag )
      hashtag_neta.valid?
      expect(hashtag_neta.errors[:hashtag_id]).to include("はすでに存在します。")
    end
  
  end

end
