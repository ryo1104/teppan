# frozen_string_literal: true

class HashtagSerializer
  include FastJsonapi::ObjectSerializer
  attributes :hashname, :yomigana
end
