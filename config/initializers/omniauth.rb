Rails.application.config.middleware.use OmniAuth::Builder do

  provider :yahoojp, ENV['YAHOOJP_KEY'], ENV['YAHOOJP_SECRET'], {scope: 'openid profile email address'}
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {scope: 'email'}
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  
  on_failure do |env|
    SessionsController.action(:failure).call(env)
  end 
end