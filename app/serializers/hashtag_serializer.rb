class HashtagSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :hashname, :hiragana
end
