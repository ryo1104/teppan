require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user)      { FactoryBot.create(:user) }
  let(:topic)     { FactoryBot.create(:topic, :with_user) }
  let(:neta)      { FactoryBot.create(:neta, :with_user, topic: topic) }

  describe 'Validations' do
    it 'is valid with a user_id and topic' do
      bookmark = Bookmark.new(bookmarkable: topic, user: user)
      expect(bookmark).to be_valid
    end

    it 'is valid with a user_id and neta' do
      bookmark = Bookmark.new(bookmarkable: neta, user: user)
      expect(bookmark).to be_valid
    end

    it 'is invalid without a user_id' do
      bookmark = Bookmark.new(bookmarkable: topic, user: nil)
      bookmark.valid?
      expect(bookmark.errors[:user]).to include('を入力してください')
    end

    it 'is invalid without a bookmarkable_id' do
      bookmark = Bookmark.new(bookmarkable_type: topic, bookmarkable_id: nil, user: user)
      bookmark.valid?
      expect(bookmark.errors[:bookmarkable]).to include('を入力してください')
    end

    it 'is invalid without a bookmarkable_type' do
      bookmark = Bookmark.new(bookmarkable_type: nil, bookmarkable_id: 1, user: user)
      bookmark.valid?
      expect(bookmark.errors[:bookmarkable]).to include('を入力してください')
    end

    it 'is invalid if duplicate bookmarks by same user' do
      Bookmark.create(bookmarkable: neta, user: user)
      bookmark = Bookmark.new(bookmarkable: neta, user: user)
      bookmark.valid?
      expect(bookmark.errors[:user_id]).to include('このお気に入りはすでに存在します。')
    end
  end
end
