# frozen_string_literal: true

class IncomingsMailbox < ApplicationMailbox
  def process
    Emailrec.create(
      from: mail.from[0],
      to: mail.to[0],
      subject: mail.subject,
      body: body,
      attachments: attachments.pluck(:blob)
    )
  end

  def attachments
    @_attachments = mail.attachments.map do |attachment|
      blob = ActiveStorage::Blob.create_after_upload!(
        io: StringIO.new(attachment.body.to_s),
        filename: attachment.filename,
        content_type: attachment.content_type
      )
      { original: attachment, blob: blob }
    end
  end

  def body
    if mail.multipart? && mail.html_part
      document = Nokogiri::HTML(mail.html_part.body.decoded)
      document.at_css('body').inner_html.encode('utf-8')
    elsif mail.multipart? && mail.text_part
      mail.text_part.body.decoded
    else
      mail.decoded
    end
  end
end
