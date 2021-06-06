# frozen_string_literal: true

class Violation < ApplicationRecord
  belongs_to  :user
  validates   :user_id, uniqueness: { scope: :reporter_id, case_sensitive: true, message: "この#{Violation.model_name.human}はすでに存在します。" }
  validates   :reporter_id, presence: true, numericality: { only_integer: true }
  validates   :block, inclusion: { in: [true, false] }
  validates   :text, length: { maximum: 400 }
end
