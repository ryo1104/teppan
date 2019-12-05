class Authorization < ApplicationRecord
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates             :uid, uniqueness: {:scope => :provider, case_sensitive: true, message: "すでにこのユーザーは登録されています。"}

  def self.find_from_auth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end
  
  def self.create_from_auth(auth)
    begin
      user_ret = User.create_from_auth!(auth)
    rescue => e
      return [false, "exception rescued while creating User from auth : #{e.message}"]
    end
    
    unless user_ret[0]
      return [false, "failed to create User record"]
    else
      begin
        authorization = self.create!(:user => user_ret[1], :uid => auth['uid'], :provider => auth['provider'])
      rescue => e
        return [false, "exception rescued while creating Authorization : #{e.message}"]
      end
      
      if authorization
        return [true, authorization]
      else
        return [false, "failed to create Authorization record"]
      end
    end
  end

end