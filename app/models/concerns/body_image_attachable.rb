module BodyImageAttachable
  extend ActiveSupport::Concern

  def body_without_images
    text = body
    text_content_index = body.index('>>>')
    if text_content_index.present?
      text = text[text_content_index + 3..-1]
    end
    text
  end

end