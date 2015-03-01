class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: Rails.application.secrets.basic_name, password: Rails.application.secrets.basic_password, except: [:health] if Rails.env.production?

  # 存在チェック
  def health
    render nothing: true
  end

end
