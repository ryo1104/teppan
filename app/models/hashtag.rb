class Hashtag < ApplicationRecord
  has_many  :hashtag_netas
  has_many  :netas, through: :hashtag_netas
  has_many  :hashtag_hits, dependent: :delete_all
  validates :hashname, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 30 }
  validates :hit_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :neta_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  def self.for_chips_autocomplete(tags)
    tags_for_chips = {}
    if tags.present?
      tags.each do |tag|
        tags_for_chips.merge!( { tag.hashname => nil } )
      end
    end
    return tags_for_chips
  end
  
  def self.for_chips_initial(tags)
    tags_for_chips = []
    if tags.present?
      tags.each do |tag|
        tags_for_chips.push( { "tag" => tag.hashname } )
      end
    end
    return tags_for_chips
  end
  
  def add_hit(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    my_count = self.hashtag_hits.where(user_id: user.id, created_at: from..to).count
    if my_count == 0
      hit_count = self.hit_count + 1
      self.hashtag_hits.create!(user_id: user.id)
      self.update!(hit_count: hit_count)
    end
  end
  
  def add_netacount
    neta_count = self.neta_count
    self.update!(neta_count: neta_count+1)
  end
  
  def self.fix_netacount
    hashtags = Hashtag.all
    hashtags.each do |hashtag|
      neta_count = 0
      neta_count = hashtag.netas.count
      hashtag.update!(neta_count: neta_count)
    end
  end
  
  def self.get_ranking(n_places)
    hashtags = Hashtag.order('hit_count desc').limit(n_places)
    hashtag_ranking = {}
    hashtags.each_with_index do |hashtag, i|
      hashtag_ranking.merge!({i => [hashtag.id, hashtag.hashname, hashtag.hit_count, hashtag.neta_count]})
    end
    return hashtag_ranking
  end
  
  def update_hiragana(force: false)
    rubyfuri = Rubyfuri::Client.new(ENV['YAHOOJP_KEY'])
    self.update(hiragana: rubyfuri.furu(self.hashname))
  end
  
end
