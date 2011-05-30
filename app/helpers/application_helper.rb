module ApplicationHelper
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(RAILS_ROOT) + '/public/images/' + image 
    tag(:img, options)
  end

end
