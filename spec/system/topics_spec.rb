require 'rails_helper'

describe "Topics", type: :system do
  before :each do
    create(:user, email: 'aaaaaa@hoge.com')
  end

  context 'as a guest' do
    it "displays the topic list" do
      visit topics_url
      expect(page).to have_content 'あなたのその鉄板ネタ、売れるかも'
    end
  end

end

# feature 'post', type: :feature do
#   scenario '投稿ができること' do
#     # 投稿ボタンが存在する
#     visit root_path
#     expect(page).to have_content('投稿')

#     # 投稿処理が動作する
#     expect {
#       click_link('投稿')
#       expect(current_path).to eq new_post_path
#       fill_in 'post_content', with: 'こんにちは'
#       fill_in 'post_tags_attributes_0_content', with: 'タグ'
#       find('input[type="submit"]').click
#     }.to change(Post, :count).by(1)

#     # トップページにリダイレクトされる
#     expect(current_path).to eq root_path

#     # 投稿内容がトップページに表示されている
#     expect(page).to have_content('こんにちは')
#   end
# end