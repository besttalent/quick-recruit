module TooltipHelper
  def tooltip_component(id:, text:, class_name: nil, show_arrow: true)
    classes = class_names("tooltip", "invisible", "opacity-0", class_name)

    content_tag(:div, id: id, role: "tooltip", class: classes) do
      concat text
      concat content_tag(:div, nil, class: "tooltip-arrow", data: { popper_arrow: true }) if show_arrow
    end
  end
end