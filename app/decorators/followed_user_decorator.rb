module FollowedUserDecorator
  def linked_name
    link_to "#{name}", "https://twitter.com/#{screen_name}", target:'_blank'
  end
end