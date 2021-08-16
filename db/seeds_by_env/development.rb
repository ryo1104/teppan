require 'faker'

# 日本語のダミーデータ
Faker::Config.locale = :ja

# Users
10.times do |n|
  user = User.create(email: Faker::Internet.email, confirmed_at: Time.zone.now, nickname: Faker::Name.name, password: 'teppan_password', introduction: Faker::Lorem.paragraph_by_chars(number: 800, supplemental: false))
  puts "user = #{user.inspect}"
end
last_user_n = User.last.id

# Topics
30.times do |n|
  user_id = Faker::Number.within(range: 1..last_user_n)
  user = User.find(user_id)
  topic = Topic.create(user: user, title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false))
  puts "topic = #{topic.inspect}"
end
last_topic_n = Topic.last.id

# Netas (free)
last_user_n.times do |n|
  user_id = Faker::Number.within(range: 1..last_user_n)
  user = User.find(user_id)
  
  5.times do |k|
    topic_id = Faker::Number.within(range: 1..last_topic_n)
    topic = Topic.find(topic_id)
    
    neta = Neta.create(user: user, topic: topic, title: Faker::Lorem.sentence, price: 0, content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false))
    puts "neta = #{neta.inspect}"
  end
end
last_neta_n = Neta.last.id

# Hashtags
50.times do |n|
  hashtag = Hashtag.create(hashname: Faker::Lorem.word)
  puts "hashtag = #{hashtag.inspect}"
end
last_hashtag_n = Hashtag.last.id

# HashtagNetas
last_neta_n.times do |n|
  neta_id = n+1
  hashtag_n_for_neta = Faker::Number.within(range: 0..10)
  hashtag_n_for_neta.times do |k|
    hashtag_id = Faker::Number.within(range: 1..last_hashtag_n)
    hashtag_neta = HashtagNeta.create(neta_id: neta_id, hashtag_id: hashtag_id)
    puts "HashtagNeta = #{hashtag_neta.inspect}"
  end
end

# Reviews
last_user_n.times do |n|
  user_id = Faker::Number.within(range: 1..last_user_n)
  user = User.find(user_id)
  
  last_neta_n.times do |k|
    neta_id = Faker::Number.within(range: 1..last_neta_n)
    neta = Neta.find(neta_id)
    
    review = Review.create(neta: neta, user: user, rate: Faker::Number.within(range: 1..5), text: Faker::Lorem.sentence)
    puts "review = #{review.inspect}"
  end
end

# Average Neta rating
netas = Neta.all
netas.each do |neta|
  avg = neta.update_average_rate
  puts "average = #{avg[1]}" if avg[0]
end

# Like
last_user_n.times do |n|
  user = User.find(n+1)
  likes_per_user = Faker::Number.within(range: 1..last_topic_n)
  likes_per_user.times do |k|
    topic_id = Faker::Number.within(range: 1..last_topic_n)
    like = Like.create(user: user, likeable_type: "Topic", likeable_id: topic_id)
    puts "like = #{like.inspect}"
  end
end

# Bookmark (Topic)
last_user_n.times do |n|
  user = User.find(n+1)
  bookmarks_per_user = Faker::Number.within(range: 1..last_topic_n)
  bookmarks_per_user.times do |k|
    topic_id = Faker::Number.within(range: 1..last_topic_n)
    bookmark = Bookmark.create(user: user, bookmarkable_type: "Topic", bookmarkable_id: topic_id)
    puts "bookmark = #{bookmark.inspect}"
  end
end

# Bookmark (Neta)
last_user_n.times do |n|
  user = User.find(n+1)
  bookmarks_per_user = Faker::Number.within(range: 1..last_neta_n)
  bookmarks_per_user.times do |k|
    neta_id = Faker::Number.within(range: 1..last_neta_n)
    bookmark = Bookmark.create(user: user, bookmarkable_type: "Neta", bookmarkable_id: neta_id)
    puts "bookmark = #{bookmark.inspect}"
  end
end

# Ranking
Ranking.create_neta_ranking(7, 10) # weekly Top10
rankings = Ranking.all
rankings.each do |ranking|
  puts "ranking = #{ranking.inspect}"
end

# Follow
last_user_n.times do |n|
  follower = User.find(n+1)
  followed_id = follower.id
  flag = false

  follows_n = Faker::Number.within(range: 1..(last_user_n-1))
  follows_n.times do |k|
    while flag == false
      followed_id = Faker::Number.within(range: 1..last_user_n)
      unless followed_id == follower.id
        follow_temp = Follow.find_by(followed_id: followed_id, follower_id: follower.id)
        if follow_temp.blank?
          follow = Follow.create(followed_id: followed_id, follower_id: follower.id)
          flag = true if follow.present?
          puts "follow = #{follow.inspect}"
        end
      end
    end
    flag = false
  end
end

# Comment
last_user_n.times do |n|
  user = User.find(n+1)
  comments_per_user = Faker::Number.within(range: 1..last_topic_n)
  comments_per_user.times do |k|
    topic_id = Faker::Number.within(range: 1..last_topic_n)
    topic = Topic.find(topic_id)
    comment = Comment.create(user: user, commentable: topic, text: Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false))
    puts "comment = #{comment.inspect}"
  end
end

# Violation
3.times do |n|
  violation_user_id = Faker::Number.within(range: 1..last_user_n)
  flag = false

  while flag == false
    reporter_id = Faker::Number.within(range: 1..last_user_n)
    unless reporter_id == violation_user_id
      violation_temp = Violation.where(user_id: violation_user_id, reporter_id: reporter_id)
      if violation_temp.blank?
        violation = Violation.create(user_id: violation_user_id, reporter_id: reporter_id, block: true, text: Faker::Lorem.paragraph_by_chars(number: 400, supplemental: false))
        flag = true if violation.persisted?
        puts "violation = #{violation.inspect}"
      end
    end
  end
end

# Bank and Branch
ZenginCode::Bank.all.each do |original_code, original_bank|
  puts "== #{original_code}:#{original_bank.name}"
  bank = Bank.find_or_initialize_by(code: original_code)
  bank.name = original_bank.name
  bank.namekana = original_bank.kana
  bank.namehira = original_bank.hira
  bank.roma = original_bank.roma
  bank.touch unless bank.new_record?
  bank.save!

  original_bank.branches.each do |original_branch_code, original_branch|
    puts "-- #{bank.code}:#{bank.name} #{original_branch_code}:#{original_branch.name}"
    branch = bank.branches.find_or_initialize_by(code: original_branch_code)
    branch.name = original_branch.name
    branch.namekana = original_branch.kana
    branch.namehira = original_branch.hira
    branch.roma = original_branch.roma
    branch.touch unless branch.new_record?
    branch.save!
  end
end
# for Stripe test env
test_bank = Bank.create(code: '1100', name: 'STRIPE TEST BANK', namekana: 'STRIPE TEST BANK', namehira: 'STRIPE TEST BANK', roma: 'STRIPE TEST BANK')
test_branch = Branch.create(bank: test_bank, code: '000', name: 'STRIPE TEST BRANCH')
puts "test_bank = #{test_bank.inspect}"
puts "test_branch = #{test_branch.inspect}"

puts "Bank: #{Bank.count}, Branch: #{Branch.count}"