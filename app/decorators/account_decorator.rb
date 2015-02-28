# coding: utf-8
module AccountDecorator

  def linked_screen_name
    link_to "@#{screen_name}", "https://twitter.com/#{screen_name}", target:'_blank'
  end

end
