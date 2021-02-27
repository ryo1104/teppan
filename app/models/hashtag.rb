class Hashtag < ApplicationRecord
  has_many  :hashtag_netas
  has_many  :netas, through: :hashtag_netas
  has_many  :hashtag_hits, dependent: :delete_all
  validates :hashname, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 30 },
                       format: { with: /\A[ぁ-んァ-ン０-９a-zA-Z0-9]+\z/, message: I18n.t('errors.messages.normal_char_only') }
  validates :hit_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :neta_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  include JpUtils

  # record only 1 hit per day per user
  def add_hit(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    if hashtag_hits.where(user_id: user.id, created_at: from..to).count == 0
      hashtag_hits.create!(user_id: user.id)
      increment(:hit_count, 1)
    end
  end

  def update_netacount
    count = netas.count
    update!(neta_count: count)
  end

  def self.fix_netacount
    hashtags = Hashtag.all
    hashtags.each do |hashtag|
      neta_count = hashtag.netas.count
      hashtag.update!(neta_count: neta_count)
    end
  end

  def self.get_ranking(n_places)
    hashtags = Hashtag.order('hit_count desc').limit(n_places)
    hashtag_ranking = {}
    hashtags.each_with_index do |hashtag, i|
      hashtag_ranking.merge!({ i => [hashtag.id, hashtag.hashname, hashtag.hit_count, hashtag.neta_count] })
    end
    hashtag_ranking
  end

  def update_hiragana
    if hashname.present?
      rubyfuri = Rubyfuri::Client.new(ENV['YAHOOJP_ID'])
      yomigana = rubyfuri.furu(hashname)
      if JpKana.hiragana(yomigana)
        self.hiragana = yomigana
        true
      else
        self.hiragana = hashname
        Rails.logger.warn("Rubyfuri returned a non hiragana : #{yomigana}")
        false
      end
    else
      false
    end
  end
end
