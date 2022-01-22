# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :neta
  counter_culture :neta
  belongs_to  :user
  validates   :user_id, uniqueness: { scope: :neta_id, message: 'このネタへのレビューは存在します。' }
  validates   :rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates   :text, length: { maximum: 200 }

  def self.details(neta_ids)
    review_hash = {}
    return review_hash if neta_ids.blank?

    reviews = Review.where(neta_id: neta_ids)
    if reviews.present?
      reviews.each do |review|
        review_hash = add_item_to_review_hash(review_hash, review)
      end
    end
    review_hash
  end

  def self.add_item_to_review_hash(review_hash, review)
    neta_id = review.neta_id
    user_id = review.user_id
    rate = review.rate
    if review_hash.key?("neta_#{neta_id}")
      review_hash["neta_#{neta_id}"].merge!({ "user_#{user_id}" => rate })
    else
      review_hash.merge!({ "neta_#{neta_id}" => { "user_#{user_id}" => rate } })
    end

    review_hash
  end

  private_class_method :add_item_to_review_hash
end
