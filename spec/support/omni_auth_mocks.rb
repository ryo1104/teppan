module OmniauthMocks
  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                   'provider' => 'twitter',
                                                                   'uid' => '123456',
                                                                   'info' => {
                                                                     'nickname' => 'MockTwitterUser',
                                                                     'image' => 'http://mock_image_url.com',
                                                                     'location' => '',
                                                                     'email' => 'mock@example.com',
                                                                     'urls' => {
                                                                       'Twitter' => 'https://twitter.com/MockUser1234',
                                                                       'Website' => ''
                                                                     }
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_credentails_token',
                                                                     'secret' => 'mock_credentails_secret'
                                                                   },
                                                                   'extra' => {
                                                                     'raw_info' => {
                                                                       'name' => 'Mock User',
                                                                       'id' => '123456',
                                                                       'followers_count' => 0,
                                                                       'friends_count' => 0,
                                                                       'statuses_count' => 0
                                                                     }
                                                                   }
                                                                 })
  end

  def twitter_invalid_mock
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentails
  end

  def yahoojp_mock
    OmniAuth.config.mock_auth[:yahoojp] = OmniAuth::AuthHash.new({
                                                                   'provider' => 'yahoojp',
                                                                   'uid' => '123456',
                                                                   'info' => {
                                                                     'name' => 'MockYahooUser',
                                                                     'gender' => 'female',
                                                                     'email' => 'mockuser@yahoo.co.jp',
                                                                     'locale' => 'ja-JP',
                                                                     'address' => {
                                                                       'country' => 'jp',
                                                                       'region' => '沖縄県'
                                                                     }
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_credentails_token'
                                                                   },
                                                                   'extra' => {
                                                                     'raw_info' => {
                                                                       'name' => 'MockYahooUser',
                                                                       'gender' => 'female',
                                                                       'email' => 'mockuser@yahoo.co.jp',
                                                                       'locale' => 'ja-JP',
                                                                       'address' => {
                                                                         'country' => 'jp',
                                                                         'region' => '沖縄県'
                                                                       }
                                                                     }
                                                                   }
                                                                 })
  end

  def yahoojp_invalid_mock
    OmniAuth.config.mock_auth[:yahoojp] = :invalid_credentails
  end

  def google_oauth2_mock
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                         'provider' => 'google_oauth2',
                                                                         'uid' => '123456',
                                                                         'info' => {
                                                                           'email' => 'mockuser@gmail.com',
                                                                           'image' => 'https://photo.jpg'
                                                                         },
                                                                         'credentials' => {
                                                                           'token' => 'mock_credentails_token'
                                                                         },
                                                                         'extra' => {
                                                                           'raw_info' => {
                                                                             'picture' => 'MockYahooUser',
                                                                             'email' => 'mockuser@gmail.com'
                                                                           }
                                                                         }
                                                                       })
  end

  def google_oauth2_invalid_mock
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentails
  end
end
