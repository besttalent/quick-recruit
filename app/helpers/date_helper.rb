module DateHelper
  def display_created_at(resource)
    display_date(resource.created_at)
  end

  def display_created_at_with_time(resource)
    resource.created_at.to_formatted_s(:long)
  end

  def display_date(date)
    return "N/A" if date.blank?
    date.to_date.to_formatted_s(:long)
  end

end