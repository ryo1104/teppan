# frozen_string_literal: true

class StripeIdcard < ApplicationRecord
  include StripeUtils
  belongs_to :stripe_account
  validates :stripe_account, uniqueness: { scope: :frontback, message: I18n.t('errors.messages.duplicate') }
  validates :frontback, inclusion: { in: %w[front back], message: I18n.t('errors.messages.duplicate') }
  validate  :stripe_file_id_check

  # custom validation
  def stripe_file_id_check
    if stripe_file_id.present? && !(stripe_file_id.starts_with? 'file_')
      errors.add(:stripe_file_id, 'stripe_file_id does not start with file_')
    end
  end

  def verification_docs
    file_id = (stripe_file_id.to_s if stripe_file_id.present?)

    {
      individual: {
        verification: {
          document: {
            "#{frontback}": file_id
          }
        }
      }
    }
  end

  def create_stripe_file(file, name)
    File.binwrite("tmp/#{name}", file.read)
    file_upload_hash = JSON.parse(Stripe::File.create({ purpose: 'identity_document', file: File.open("tmp/#{name}", 'r') }).to_s)
    File.delete("tmp/#{name}")
    file_upload_hash
  end
end
