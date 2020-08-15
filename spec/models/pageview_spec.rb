require 'rails_helper'

RSpec.describe Pageview, type: :model do
  let(:user)  { FactoryBot.create(:user) }
  let(:topic) { FactoryBot.create(:topic, :with_user) }
  let(:neta)  { FactoryBot.create(:neta, :with_user, topic: topic) }

  describe 'Validations' do
    it 'is valid with a topic and user' do
      pageview = Pageview.new(pageviewable: topic, user: user)
      expect(pageview).to be_valid
    end

    it 'is valid with a neta and user' do
      pageview = Pageview.new(pageviewable: neta, user: user)
      expect(pageview).to be_valid
    end

    it 'is invalid without a pageviewable' do
      pageview = Pageview.new(pageviewable: nil, user: user)
      pageview.valid?
      expect(pageview.errors[:pageviewable]).to include('を入力してください')
    end

    it 'is invalid without a user' do
      pageview = Pageview.new(pageviewable: neta, user: nil)
      pageview.valid?
      expect(pageview.errors[:user]).to include('を入力してください')
    end
  end
end
