# frozen_string_literal: true

class Branch < ApplicationRecord
  validates :bank_id, uniqueness: { scope: :code }
  belongs_to :bank
end
