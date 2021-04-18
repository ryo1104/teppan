require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  describe 'Validations' do
    it 'is invalid without an email address' do
      inquiry = build(:inquiry, email: '')
      inquiry.valid?
      expect(inquiry.errors[:email]).to include('を入力してください。')
    end

    it 'is invalid with an invalid email address 1' do
      inquiry = build(:inquiry, email: 'testtest')
      inquiry.valid?
      expect(inquiry.errors[:email]).to include('が正しくありません。')
    end

    it 'is invalid with an invalid email address 2' do
      inquiry = build(:inquiry, email: '@abc.com')
      inquiry.valid?
      expect(inquiry.errors[:email]).to include('が正しくありません。')
    end

    it 'is invalid with an invalid email address 3' do
      inquiry = build(:inquiry, email: 'abc@')
      inquiry.valid?
      expect(inquiry.errors[:email]).to include('が正しくありません。')
    end

    it 'is valid with a valid email address' do
      inquiry = build(:inquiry)
      inquiry.valid?
      expect(inquiry).to be_valid
    end

    it 'is invalid if message is blank' do
      inquiry = build(:inquiry, email: 'aaa@bbbccc.com', message: nil)
      inquiry.valid?
      expect(inquiry.errors[:message]).to include('を入力してください。')
    end

    it 'is invalid if message is longer than 400 characters' do
      inquiry = build(:inquiry, email: 'aaa@bbbccc.com', message: Faker::Lorem.characters(number: 401))
      inquiry.valid?
      expect(inquiry.errors[:message]).to include('は400文字以内で入力してください。')
    end
  end
end
