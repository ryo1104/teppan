# frozen_string_literal: true

namespace :hashtag do
  desc 'hashtag.hashnameに読み仮名をつける'
  # rake hashtag:update_hiragana
  task update_hiragana: :environment do
    Hashtag.all.each(&:update_hiragana)
  end
end
