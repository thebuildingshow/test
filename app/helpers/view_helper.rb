App.helpers do
  def selected_class(block)
    block.selected ? "selected" : "not-selected"
  end

  def connectable_classes(connectable)
    classes = []
    classes << connectable._class.downcase
    classes << (connectable.has_image? ? "yes-image" : "no-image")
    classes.join(" ")
  end

  def image_proxy_path(src, dimensions="900x900")
    "http://d2ss1gpcas6f9e.cloudfront.net/q/resize/#{dimensions}%3E/src/#{CGI.escape(src)}"
  end

  def download_string(block)
    "Download #{block.attachment.file_name} (#{block.attachment.file_size_display} .#{block.attachment.extension})"
  end

  def channel_or_block_path(block)
    block.is_channel? ? "/#{encode(block.slug)}" : "/view/#{encode(block.id.to_s)}"
  end

  def display_metadata?(block)
    block.title || block.description_html
  end

  def appropriate_image(block)
    block.selected && block.has_image? ? block.image.display.url : block.image.thumb.url
  end

  def appropriate_link(block)
    if block.is_link?
      block.source.url
    elsif block.is_attachment?
      block.attachment.url
    elsif block.has_image?
      block.image.original.url
    end
  end

  def appropriate_preview(block)
    if block.has_image?
      image_tag appropriate_image(block), alt: block.generated_title
    elsif block.is_text?
      Sanitize.clean(block.content_html, elements: %w(p br b i strong em))
    else
      block.generated_title
    end
  end
end
