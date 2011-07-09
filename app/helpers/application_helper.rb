module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Wine App Logo", :class => "round")
  end

  # Return a title on a per-page basis.
  def title
    base_title = "Wine Collector's Application Prototype"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end

