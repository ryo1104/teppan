class Authorization < ApplicationRecord
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates             :uid, uniqueness: {:scope => :provider, case_sensitive: true, message: "すでにこのユーザーは登録されています。"}
  include JpPrefecture

  def self.find_from_auth(auth)
    if auth = self.find_by_provider_and_uid(auth['provider'], auth['uid'])
      return [true, auth]
    else
      return [false, "cannot find Auth record : provider #{auth['provider']}, uid #{auth['uid']}"]
    end
  end
  
  def self.create_from_auth(auth)

    auth_inputs = get_auth_inputs(auth)
    user_ret = User.create_from_auth(auth_inputs)
    unless user_ret[0]
      return [false, "failed to create User"]
    else
      authorization = self.create(:user => user_ret[1], :uid => auth['uid'], :provider => auth['provider'])
      if authorization
        return [true, authorization]
      else
        return [false, "failed to create Authorization record"]
      end
    end

  end
  
  def get_auth_inputs(auth)

    if auth.present?

      case auth['provider']

        when "yahoojp" then
          email = auth['info']['email']
          nickname = email.split("@")[0]
          
          case auth['info']['gender']
          when "male" then
            gender = 1
          when "female" then
            gender = 2
          else
            gender = nil
          end
          
          if auth['info']['address']['country'] == "jp"
            if auth['info']['address']['region'].present?
              prefecture = JpPrefecture::Prefecture.find(name: auth['info']['address']['region'])
              if prefecture
                prefecture_code = prefecture.code
              else
                prefecture_code = nil
              end
            else
              prefecture_code = nil
            end
          else
            prefecture_code = nil
          end
          
        when "google_oauth2" then
          email = auth['info']['email']
          nickname = email.split("@")[0]
          gender = nil
          prefecture_code = nil
          
        when "twitter" then
          nickname = auth['info']['nickname']
          email = nickname + "@hoge.com" 
          #twitter APIでPrivacyPolicy等の設定をすれば取得可能になる
          # email = auth['info']['email']
          gender = nil
          prefecture_code = nil
          
        else
          return [false, "unknown provider"]
      end
      
      result = { "email" => email,
                 "nickname" => nickname, 
                 "gender" => gender,
                 "prefecture_code" => prefecture_code
               }
    else
      return [false, "auth is empty"]
    end

    return result
  end  

end