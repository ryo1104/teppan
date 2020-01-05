class Ranking < ApplicationRecord
  belongs_to :rankable, polymorphic: true
  
  def self.create_neta_ranking(span, top_x)
    list = Ranking.generate_neta_ranks(span, top_x)
    Ranking.transaction do
      Ranking.where(rankable_type: "Neta").destroy_all
      list.each_with_index do |item, i|
        Ranking.create!(rankable_type: "Neta", rank: i+1, rankable_id: item[1]["neta_id"].to_i, score: item[1]["score"].to_f)
      end
    end
  end
  
  def self.generate_neta_ranks(span, top_x)
    from = Time.zone.now - span.days
    to = Time.zone.now
    netas = Neta.where(created_at: from..to)
    fulllist = {}
    netas.each_with_index do |neta, i|
      score = 0
      score = neta.pageviews_count + neta.interests_count*5 + neta.reviews_count*neta.average_rate*10 + neta.price*0.1
      fulllist.merge!({neta.id => score})
    end
    sorted_full = fulllist.sort_by{|k, v| v}.reverse
    ret_list = {}
    sorted_full.each_with_index do |data, i|
      if i < top_x
        ret_list.merge!({"rank_"+"#{i+1}" => {"neta_id" => data[0], "score" => data[1]}})
      else
        break
      end
    end
    return ret_list
  end

end