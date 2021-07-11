class AddForeignKeys < ActiveRecord::Migration[6.0]
  def up
    add_foreign_key :bookmarks, :users
    add_foreign_key :branches, :banks
    add_foreign_key :comments, :users
    add_foreign_key :copychecks, :netas
    add_foreign_key :follows, :users
    add_foreign_key :hashtag_hits, :hashtags
    add_foreign_key :hashtag_hits, :users
    add_foreign_key :hashtag_netas, :netas
    add_foreign_key :hashtag_netas, :hashtags
    add_foreign_key :likes, :users
    add_foreign_key :netas, :users
    add_foreign_key :netas, :topics
    add_foreign_key :pageviews, :users
    add_foreign_key :reviews, :netas
    add_foreign_key :reviews, :users
    add_foreign_key :stripe_accounts, :users
    add_foreign_key :stripe_idcards, :stripe_accounts
    add_foreign_key :stripe_payouts, :stripe_accounts
    add_foreign_key :topics, :users
    add_foreign_key :violations, :users
  end
  
  def down
    remove_foreign_key :bookmarks, :users
    remove_foreign_key :branches, :banks
    remove_foreign_key :comments, :users
    remove_foreign_key :copychecks, :netas
    remove_foreign_key :follows, :users
    remove_foreign_key :hashtag_hits, :hashtags
    remove_foreign_key :hashtag_hits, :users
    remove_foreign_key :hashtag_netas, :netas
    remove_foreign_key :hashtag_netas, :hashtags
    remove_foreign_key :likes, :users
    remove_foreign_key :netas, :users
    remove_foreign_key :netas, :topics
    remove_foreign_key :pageviews, :users
    remove_foreign_key :reviews, :netas
    remove_foreign_key :reviews, :users
    remove_foreign_key :stripe_accounts, :users
    remove_foreign_key :stripe_idcards, :stripe_accounts
    remove_foreign_key :stripe_payouts, :stripe_accounts
    remove_foreign_key :topics, :users
    remove_foreign_key :violations, :users
  end
end
