# frozen_string_literal: true

Time::DATE_FORMATS[:default] = '%Y/%m/%d %H:%M'
Time::DATE_FORMATS[:datetime] = '%Y/%m/%d %H:%M'
Time::DATE_FORMATS[:date] = '%Y/%m/%d'
Time::DATE_FORMATS[:time] = '%H:%M:%S'
Date::DATE_FORMATS[:default] = '%Y/%m/%d'

Time::DATE_FORMATS[:human] = lambda { |date|
  seconds = (Time.zone.now - date).round

  years = seconds / (60 * 60 * 24 * 30 * 12)
  return '#１年以上前' if years.positive?

  months = seconds / (60 * 60 * 24 * 30)
  return "#{months}ヶ月前" if months.positive?

  days = seconds / (60 * 60 * 24)
  return "#{days}日前" if days.positive?

  hours = seconds / (60 * 60)
  return "#{hours}時間前" if hours.positive?

  minutes = seconds / 60
  return "#{minutes}分前" if minutes.positive?

  return "#{seconds}秒前"
}
