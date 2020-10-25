module ApplicationHelper
  require 'uri'

  def page_title
    if @page_title
      @page_title + ' | Teppan'
    else
      'Teppan | ネタ話のフリマサイト'
    end
  end

end
