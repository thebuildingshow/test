Generic.helpers do

  def selected_class(block)
    block.selected ? "selected" : "not-selected"
  end

  def image_proxy_path(src, dimensions='900x900')
    "http://d2ss1gpcas6f9e.cloudfront.net/q/resize/#{dimensions}%3E/src/#{CGI.escape(src)}"
  end

  def channel_or_block_path(block)
    is_channel?(block) ? "/#{encode(block.slug)}" : "/view/#{encode(block.id.to_s)}"
  end

  def display_metadata?(block)
    block.title || block.description_html
  end

  def appropriate_image(block)
    block.selected && block.has_image? ? block.image.display.url : block.image.thumb.url
  end

  def appropriate_link(block)
    if is_link?(block)
      block.source.url
    elsif is_attachment?(block)
      block.attachment.url
    elsif block.has_image?
      block.image.original.url
    end
  end

  def appropriate_preview(block)
    if block.has_image?
      image_tag appropriate_image(block)
    elsif is_text?(block)
      block.content_html
    else
      block.generated_title
    end
  end

  [:image, :text, :link, :media, :attachment, :channel].each do |type|
    define_method "is_#{type}?" do |block|
      block._class == type.to_s.capitalize
    end
  end

end
