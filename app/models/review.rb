# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :neta
  counter_culture :neta
  belongs_to  :user
  validates   :user_id, uniqueness: { scope: :neta_id, message: 'このネタへのレビューは存在します。' }
  validates   :rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates   :text, length: { maximum: 200 }

  def self.details_from_ids(parent_class, ids)
    review_hash = {}

    if parent_class == 'Neta'
      reviews = Review.where(neta_id: ids)
    elsif parent_class == 'User'
      reviews = Review.where(user_id: ids)
    else
      return false
    end

    if reviews.present?
      reviews.each do |review|
        review_hash.merge!({ 'neta_' + review.neta_id.to_s + '_user_' + review.user_id.to_s => { 'rate' => review.rate } })
      end
    end

    review_hash
  end
end
