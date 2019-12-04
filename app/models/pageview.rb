class Pageview < ApplicationRecord
  belongs_to  :user
  belongs_to  :pageviewable, polymorphic: true
  counter_culture :pageviewable
  
  def self.get_history(type, user_id, span, n_limit)
    if span.is_a?(Integer)
      if span > 0
        from = Time.zone.now - span.days
        to = Time.zone.now
      else
        return [1, "span days invalid. span : #{span}"]
      end
    else
      return [1, "span days is non integer. span : #{span}"]
    end
    views = Pageview.includes(:pageviewable).where(pageviewable_type: type, user_id: user_id, created_at: from..to).order("created_at DESC").limit(n_limit)
    return views
  end
end
