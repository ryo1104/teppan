module ApplicationHelper
  require "uri" 

  def page_title
    title = "Teppan"
    if @page_title
      title = @page_title + " | " + title 
    else
      title = title + " | ネタ話のフリマサイト" 
    end
  end
  
  def text_extract_links(text)
    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end
    return text
  end
  
  def remove_hashtags(text)
    text.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| ""}
  end
  
  def devise_error_messages
    return "" if resource.errors.empty?
    html = ""
    # エラーメッセージ用のHTMLを生成
    messages = resource.errors.full_messages.each do |msg|
      html += <<-EOF
      <div class="error-message">#{msg}</div><br>
      EOF
    end
    html.html_safe
  end

end
