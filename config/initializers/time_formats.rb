Time::DATE_FORMATS[:human] = lambda { |date|
  seconds = (Time.now - date).round
  years   = seconds / (60 * 60 * 24 * 30 * 12); return '#１年以上前' if years > 0

  months = seconds / (60 * 60 * 24 * 30); return "#{months}ヶ月前" if months > 0

  days = seconds / (60 * 60 * 24); return "#{days}日前" if days > 0

  hours = seconds / (60 * 60); return "#{hours}時間前" if hours > 0

  minutes = seconds / 60; return "#{minutes}分前" if minutes > 0

  return "#{seconds}秒前"
}
