# frozen_string_literal: true

class HashtagNeta < ApplicationRecord
  belongs_to :neta
  belongs_to :hashtag
  counter_culture :hashtag, column_name: 'neta_count'
  validates  :neta_id, presence: true
  validates  :hashtag_id, presence: true, uniqueness: { scope: :neta_id }
end
