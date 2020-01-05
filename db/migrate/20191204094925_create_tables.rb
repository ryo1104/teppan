class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tables, id: :integer do |t|
      
      create_table "accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.string "stripe_acct_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.string "stripe_status"
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
    
      create_table "authorizations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
        t.string "provider"
        t.string "uid"
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true
      end
    
      create_table "banks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.string "code", default: "", null: false
        t.string "name", default: "", null: false
        t.string "name_kana", default: "", null: false
        t.string "name_hira", default: "", null: false
        t.string "name_en", default: "", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["code"], name: "index_banks_on_code", unique: true
      end
    
      create_table "branches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.string "code", default: "", null: false
        t.string "name", default: "", null: false
        t.string "name_kana", default: "", null: false
        t.string "name_hira", default: "", null: false
        t.string "name_en", default: "", null: false
        t.integer "bank_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["bank_id", "code"], name: "index_branches_on_bank_id_and_code", unique: true
      end
    
      create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.text "text", limit: 16777215
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "commentable_id"
        t.string "commentable_type"
        t.integer "likes_count", default: 0, null: false
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
        t.text "text", limit: 16777215
      end
    
      create_table "externalaccounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "account_id"
        t.string "stripe_bank_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "follows", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.integer "follower_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "hashtag_hits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "hashtag_id"
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "hashtag_netas", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "neta_id"
        t.integer "hashtag_id"
        t.index ["hashtag_id"], name: "index_hashtag_netas_on_hashtag_id"
        t.index ["neta_id"], name: "index_hashtag_netas_on_neta_id"
      end
    
      create_table "hashtags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.string "hashname"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "hit_count", default: 0, null: false
        t.integer "neta_count", default: 0, null: false
        t.index ["hashname"], name: "index_hashtags_on_hashname", unique: true
      end
    
      create_table "idcards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "account_id"
        t.string "frontback"
        t.string "stripe_file_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "interests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "interestable_id"
        t.string "interestable_type"
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "likes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.integer "likeable_id"
        t.string "likeable_type"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "netas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.text "text", limit: 16777215
        t.integer "price"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "topic_id"
        t.text "valuetext"
        t.integer "reviews_count", default: 0, null: false
        t.integer "pageviews_count", default: 0, null: false
        t.float "average_rate", default: 0.0
        t.integer "interests_count", default: 0, null: false
        t.boolean "private_flag", default: false, null: false
      end
    
      create_table "pageviews", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "pageviewable_id"
        t.string "pageviewable_type"
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "payouts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "account_id"
        t.string "stripe_payout_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
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
        t.text "text", limit: 16777215
        t.integer "rate"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "likes_count", default: 0, null: false
        t.integer "comments_count", default: 0, null: false
      end
    
      create_table "subscriptions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.string "stripe_sub_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      create_table "topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.string "title"
        t.text "text", limit: 16777215
        t.integer "user_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "pageviews_count", default: 0, null: false
        t.integer "likes_count", default: 0, null: false
        t.integer "interests_count", default: 0, null: false
        t.integer "netas_count", default: 0, null: false
        t.integer "comments_count", default: 0, null: false
      end
    
      create_table "trades", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "buyer_id"
        t.integer "price"
        t.string "tradetype"
        t.string "tradestatus"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.integer "tradeable_id"
        t.string "tradeable_type"
        t.integer "seller_id"
        t.string "stripe_charge_id"
      end
    
      create_table "violations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", force: :cascade do |t|
        t.integer "user_id"
        t.integer "reporter_id"
        t.text "text", limit: 16777215
        t.integer "block"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
      end
    
      add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
      
    end
  end
end