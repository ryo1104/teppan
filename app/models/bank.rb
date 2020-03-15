class Bank < ApplicationRecord
  require 'zengin_code'
  validates :code, presence: true, uniqueness: { case_sensitive: true }
  has_many :branches, dependent: :destroy
  
  def get_all
    return ZenginCode::Bank.all
  end
  
end
