class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= Sender.find(session[:sender_id]) if session[:sender_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def authorize_admin
    redirect_to '/senders/not_admin' unless current_user.admin
  end
end
