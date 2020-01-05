class Inquiry < ApplicationRecord
  validates :email, length: {maximum:255}, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, allow_blank: true
  validates :email, presence: true
  validates :message, presence: true
end
