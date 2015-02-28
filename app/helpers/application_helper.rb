module ApplicationHelper
  def tab_pane(i, options, &block)
    classes = %w(tab-pane fade)
    classes += %w(in active) if i == 0
    options[:class] = classes.join("\s")
    content_tag(:div, options, &block)
  end

  def nav_list(name1, name2, &block)
    if name1 == name2
      content_tag(:li, {class: 'active'}, &block)
    else
      content_tag(:li, {}, &block)
    end
  end
end
