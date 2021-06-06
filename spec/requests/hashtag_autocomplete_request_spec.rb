require 'rails_helper'

RSpec.describe 'HashtagAutocompletes', type: :request do
  before do
    @hashtag1 = create(:hashtag, hashname: '野球', yomigana: 'やきゅう', neta_count: 5)
    @hashtag2 = create(:hashtag, hashname: 'サッカー', yomigana: 'さっかー', neta_count: 7)
    @hashtag3 = create(:hashtag, hashname: '水泳', yomigana: 'すいえい', neta_count: 2)
    @hashtag4 = create(:hashtag, hashname: 'テニス', yomigana: 'てにす', neta_count: 5)
    @hashtag5 = create(:hashtag, hashname: '卓球', yomigana: 'たっきゅう', neta_count: 8)
    @hashtag6 = create(:hashtag, hashname: '茶道', yomigana: 'さどう', neta_count: 1)
  end
  it 'returns a 200 status code' do
    get hashtags_autocomplete_index_url, params: { keyword: '' }
    expect(response).to have_http_status('200')
  end
  it 'returns the neta set filtered by keyword' do
    get hashtags_autocomplete_index_url, params: { keyword: 'きゅう' }
    expected_result = [
      { 'id' => @hashtag5.id.to_s, 'type' => 'hashtag', 'attributes' => { 'hashname' => '卓球', 'yomigana' => 'たっきゅう' } },
      { 'id' => @hashtag1.id.to_s, 'type' => 'hashtag', 'attributes' => { 'hashname' => '野球', 'yomigana' => 'やきゅう' } }
    ]
    expect(JSON.parse(response.body)['data']).to eq expected_result
  end
end
