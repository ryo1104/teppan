class HashtagSerializer
  include FastJsonapi::ObjectSerializer
  attributes :hashname, :hiragana
end