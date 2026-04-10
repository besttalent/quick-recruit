module UrlHelper
  def absolute_url(path)
    return path if path.blank?

    if path.include?("https://") || path.include?("http://")
      path
    else
      path.prepend("https://")
    end
  end
end
