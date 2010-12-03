module ApplicationHelper

=begin
  def render_flash(tag = nil)
    if tag.empty?
      out = ""
      %w(error notice info).each do |tag|
        out << render_flash(tag)
      end
    end else
      if flash[tag.to_sym]
        
        content_tag(:table, :border => 0, :width => "100%", :cellpadding => "0", :cellspacing => "0") do
          content_tag(:tr, false) do
            content_tag(:td, :class => "yellow-left"
  end
=end
  
end
