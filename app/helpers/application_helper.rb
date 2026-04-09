module ApplicationHelper
  include AvatarHelper
  include ButtonHelper
  include AutoLinkHelper
  include SvgHelper
  include TooltipHelper
  include DateHelper
  include FormHelper
  
  def auto_link_urls_in_text(text)
    auto_link(text, html: { class: "text-indigo-700 hover:underline", target: "_blank" })
  end

  def absolute_url(path)
    if path.include?("https://") || path.include?("http://")
      path
    else
      path.prepend("https://")
    end
  end

end
