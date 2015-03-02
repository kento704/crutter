# coding: utf-8
module AccountDecorator

  def linked_screen_name
    link_to "@#{screen_name}", "https://twitter.com/#{screen_name}", target:'_blank'
  end

  def linked_target_name
    link_to "#{target_name}", "https://twitter.com/#{target_screen_name}", target:'_blank'
  end

end
