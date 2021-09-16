# frozen_string_literal: true

class Emailrec < ApplicationRecord
  has_rich_text :body
  has_many_attached :attachments
  validates :from, presence: true
  validates :to, presence: true
end
