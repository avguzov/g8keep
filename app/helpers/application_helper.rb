module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "g8keep"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
	image_tag("logo.png", :alt => "g8keep", :class => "round")
  end
end
