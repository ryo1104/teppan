# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
#
# development 環境のデータを初期化するコマンド
# rails db:migrate:reset RAILS_ENV=development
#
# development 環境にSeedデータを追加するコマンド
# rails db:seed RAILS_ENV=development

# 環境別にseed ファイルを読み込む
load(Rails.root.join("db", "seeds_by_env", "#{Rails.env.downcase}.rb"))
