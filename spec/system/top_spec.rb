require 'rails_helper'

describe "Top", type: :system do

  it 'displays the top page' do
    visit root_url
    expect(find('.top-page__logo-image')).to be_visible
    expect(page).to have_content 'あなたのその鉄板ネタ、売れるかも'
  end
  
end