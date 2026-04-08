module SvgHelper
  def svg_icon(name, class_name: nil)
    file_path = Rails.root.join("app/assets/images/icons/#{name}.svg")
    return "".html_safe unless File.exist?(file_path)

    svg = File.read(file_path)
    return svg.html_safe if class_name.blank?

    escaped_class = ERB::Util.html_escape(class_name)

    if svg.match?(/class="[^"]*"/)
      svg.sub(/class="([^"]*)"/) { %(class="#{$1} #{escaped_class}") }.html_safe
    else
      svg.sub("<svg", %(<svg class="#{escaped_class}")).html_safe
    end
  end
end