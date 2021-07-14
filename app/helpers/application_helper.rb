# frozen_string_literal: true

module ApplicationHelper
  require 'uri'

  def page_title
    if @page_title
      @page_title + ' | Teppan'
    else
      'Teppan | ネタ話のフリマサイト'
    end
  end
  
  def page_description
    if @page_description
      @page_description
    else
      'あなたのその鉄板ネタ、売れるかも？ここぞという時の鉄板ネタ、買えるかも？'
    end
  end
end
