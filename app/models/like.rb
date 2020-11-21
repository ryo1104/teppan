class Like < ApplicationRecord
  belongs_to  :user
  belongs_to  :likeable, polymorphic: true
  counter_culture :likeable
  validates :user_id, uniqueness: { scope: %i[likeable_type likeable_id], message: I18n.t('errors.messages.taken') }
end
