# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_07_141249) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "banks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.string "name", default: "", null: false
    t.string "namekana", default: "", null: false
    t.string "namehira", default: "", null: false
    t.string "roma", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_banks_on_code", unique: true
  end

  create_table "bookmarks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "bookmarkable_id"
    t.string "bookmarkable_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "bookmarkable_type", "bookmarkable_id"], name: "unique_bookmark", unique: true
  end

  create_table "branches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "code", default: "", null: false
    t.string "name", default: "", null: false
    t.string "namekana", default: "", null: false
    t.string "namehira", default: "", null: false
    t.string "roma", default: "", null: false
    t.integer "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id", "code"], name: "index_branches_on_bank_id_and_code", unique: true
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.text "text", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "likes_count", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "fk_rails_03de2dc08c"
  end

  create_table "copycheck_statuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "copycheck_textlikes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "queue_id"
    t.integer "like_queue_id"
    t.integer "percent"
  end

  create_table "copycheck_weblikes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "queue_id"
    t.integer "distance"
    t.string "url"
    t.string "text"
  end

  create_table "copychecks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "neta_id"
    t.integer "web_like_status"
    t.integer "web_like_percent"
    t.integer "web_match_status"
    t.integer "web_match_percent"
    t.integer "text_match_status"
    t.integer "text_match_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "queue_id"
    t.text "text", size: :medium
    t.index ["neta_id"], name: "fk_rails_95e11130c3"
  end

  create_table "follows", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "followed_id"
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "hashtag_hits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "hashtag_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashtag_id"], name: "fk_rails_42fb40a9cb"
    t.index ["user_id"], name: "fk_rails_d4395efe2f"
  end

  create_table "hashtag_netas", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "neta_id"
    t.integer "hashtag_id"
    t.index ["hashtag_id"], name: "fk_rails_4423013fcc"
    t.index ["neta_id", "hashtag_id"], name: "index_hashtag_netas_on_neta_id_and_hashtag_id", unique: true
  end

  create_table "hashtags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "hashname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hit_count", default: 0, null: false
    t.integer "neta_count", default: 0, null: false
    t.string "yomigana"
    t.index ["hashname"], name: "index_hashtags_on_hashname", unique: true
  end

  create_table "inquiries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "likeable_id"
    t.string "likeable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "likeable_type", "likeable_id"], name: "unique_like", unique: true
  end

  create_table "netas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.text "title", size: :medium
    t.integer "price", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
    t.integer "reviews_count", default: 0, null: false
    t.integer "pageviews_count", default: 0, null: false
    t.float "average_rate", default: 0.0
    t.integer "bookmarks_count", default: 0, null: false
    t.boolean "private_flag", default: false, null: false
    t.index ["topic_id"], name: "fk_rails_db6e4640ce"
    t.index ["user_id"], name: "fk_rails_128dac0d75"
  end

  create_table "pageviews", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "pageviewable_id"
    t.string "pageviewable_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_3fdda99dcd"
  end

  create_table "rankings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "rankable_type"
    t.integer "rank"
    t.integer "rankable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "score", default: 0.0
  end

  create_table "reviews", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "neta_id"
    t.integer "user_id"
    t.text "text", size: :medium
    t.integer "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neta_id"], name: "fk_rails_4564c578b1"
    t.index ["user_id", "neta_id"], name: "unique_review", unique: true
  end

  create_table "stripe_accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "acct_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "ext_acct_id"
    t.index ["acct_id"], name: "index_stripe_accounts_on_acct_id", unique: true
    t.index ["ext_acct_id"], name: "index_stripe_accounts_on_ext_acct_id", unique: true
    t.index ["user_id"], name: "index_stripe_accounts_on_user_id", unique: true
  end

  create_table "stripe_idcards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "stripe_account_id"
    t.string "frontback"
    t.string "stripe_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_account_id", "frontback"], name: "unique_idcard", unique: true
  end

  create_table "stripe_payouts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "stripe_account_id"
    t.string "payout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount", default: 0, null: false
    t.index ["payout_id"], name: "index_stripe_payouts_on_payout_id", unique: true
    t.index ["stripe_account_id"], name: "fk_rails_981e366b28"
  end

  create_table "topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pageviews_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "bookmarks_count", default: 0, null: false
    t.integer "netas_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.boolean "private_flag", default: false, null: false
    t.string "header_img_url"
    t.index ["title"], name: "index_topics_on_title", unique: true
    t.index ["user_id"], name: "fk_rails_7b812cfb44"
  end

  create_table "trades", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "buyer_id", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.string "tradetype"
    t.string "tradestatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tradeable_id", default: 0, null: false
    t.string "tradeable_type", default: "0", null: false
    t.integer "seller_id", default: 0, null: false
    t.string "stripe_ch_id"
    t.string "stripe_pi_id"
    t.integer "seller_revenue"
    t.integer "fee"
    t.integer "c_tax"
    t.index ["buyer_id", "seller_id", "tradeable_type", "tradeable_id"], name: "unique_trade", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname"
    t.date "birthdate"
    t.integer "gender"
    t.string "stripe_cus_id"
    t.integer "followers_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "unregistered", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.string "avatar_img_url"
    t.integer "followings_count", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "violations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "reporter_id", default: 0, null: false
    t.text "text", size: :medium
    t.boolean "block", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "reporter_id"], name: "unique_violation", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "branches", "banks"
  add_foreign_key "comments", "users"
  add_foreign_key "copychecks", "netas"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "hashtag_hits", "hashtags"
  add_foreign_key "hashtag_hits", "users"
  add_foreign_key "hashtag_netas", "hashtags"
  add_foreign_key "hashtag_netas", "netas"
  add_foreign_key "likes", "users"
  add_foreign_key "netas", "topics"
  add_foreign_key "netas", "users"
  add_foreign_key "pageviews", "users"
  add_foreign_key "reviews", "netas"
  add_foreign_key "reviews", "users"
  add_foreign_key "stripe_accounts", "users"
  add_foreign_key "stripe_idcards", "stripe_accounts"
  add_foreign_key "stripe_payouts", "stripe_accounts"
  add_foreign_key "topics", "users"
  add_foreign_key "violations", "users"
end
