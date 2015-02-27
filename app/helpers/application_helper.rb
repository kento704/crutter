module ApplicationHelper
  def tab_pane(i, options, &block)
    classes = %w(tab-pane fade)
    classes += %w(in active) if i == 0
    options[:class] = classes.join("\s")
    content_tag(:div, options, &block)
  end
end
