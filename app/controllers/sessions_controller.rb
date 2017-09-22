class SessionsController < ApplicationController
  before_action :authorize

  def new
  end

  def create
    user = Sender.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:sender_id] = user.id
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:sender_id] = nil
    redirect_to '/login'
  end

  def not_admin
  end

  def not_user
  end
end
