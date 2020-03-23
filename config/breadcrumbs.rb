crumb :root do
  link "トップ", root_path
end

# neta#index
crumb :netas do
  link "小ネタ一覧", netas_path
  parent :root
end

# topic#index
crumb :topics do
  link "トピック一覧", topics_path
  parent :root
end

# topic#show
crumb :show_topic do |topic|
  link "#{topic.title}", topic_path(topic.id)
  parent :topics
end

# topic#new
crumb :new_topic do
  link "新規トピック", new_topic_path
  parent :topics
end

# topic#edit
crumb :edit_topic do |topic|
  link "トピック編集", edit_topic_path(topic.id)
  parent :show_topic, topic
end

# ネタshow
crumb :show_neta do |neta|
  link neta.title, neta_path(neta.id)
  parent :show_topic, neta.topic
end

# ネタnew
crumb :new_neta do |topic|
  link "新規ネタ", new_topic_neta_path
  parent :show_topic, topic
end

# ネタedit
crumb :edit_neta do |neta|
  link "編集", edit_neta_path(neta.id)
  parent :show_neta, neta
end

# user#show
crumb :show_review do |review|
  link "レビュー", review_path(review.id)
  parent :show_neta, review.neta
end

# レビュー#show
crumb :show_user do |user|
  link "#{user.nickname}", user_path(user.id)
  parent :root
end

# user#edit
crumb :edit_user do |user|
  link "プロフィール変更", edit_user_path(user.id)
  parent :show_user, user
end

# user#edit_registration
crumb :edit_user_registration do |user|
  link "パスワード変更", edit_user_registration_path(user.id)
  parent :show_user, user
end

# netas#hashtags
crumb :hashtag do |tag|
  link "#"+"#{tag.hashname}", "/neta/hashtag/#{tag.hashname}"
  parent :topics
end

# subscriptions#show
crumb :show_subscription do |user|
  link "プラン内容", user_subscription_path(user.id, user.subscription.id)
  parent :show_user, user
end

# subscriptions#new
crumb :new_subscription do |user|
  link "プラン申込", new_user_subscription_path(user.id)
  parent :show_user, user
end

# account#show
crumb :show_account do |account|
  link "ビジネスアカウント", account_path(account.id)
  parent :show_user, account.user
end

# account#show
crumb :edit_account do |account|
  link "お客様情報", edit_account_path(account.id)
  parent :show_account, account
end

# idcard#new
crumb :new_idcard do |account|
  link "ご本人様確認", new_account_idcard_path(account.id)
  parent :show_account, account
end

# externalaccount#new
crumb :new_externalaccount do |account|
  link "銀行口座", new_account_externalaccount_path(account.id)
  parent :show_account, account
end

# externalaccount#edit
crumb :edit_externalaccount do |ext_account|
  link "銀行口座", edit_externalaccount_path(ext_account.id)
  parent :show_account, ext_account.account
end
