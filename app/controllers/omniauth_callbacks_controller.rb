class OmniauthCallbacksController < ApplicationController
  def twitter
    auth        = request.env["omniauth.auth"]
    screen_name = auth.extra.access_token.params[:screen_name]
    account     = Account.find_by(screen_name: screen_name)
    unless account
      account = Account.create(
        screen_name:        screen_name,
        oauth_token:        auth.credentials.token,
        oauth_token_secret: auth.credentials.secret
      )
    end
    redirect_to :root
  end
end