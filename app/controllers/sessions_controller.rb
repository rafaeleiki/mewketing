class SessionsController < ApplicationController

  def new
      @errors = []
  end

  def create
    user = Sender.find_by_email(params[:email])
    respond_to do |format|
        if user && user.authenticate(params[:password])
          session[:sender_id] = user.id
          redirect_to '/'
        else
          format.html { redirect_to '/login', notice: 'User and password doens\'t match' }
          format.json { render json: {errors: ['User and Pass doens\'t match']}, status: :unprocessable_entity }
        end
    end
  end

  def destroy
    session[:sender_id] = nil
    redirect_to '/login'
  end

  def not_admin
  end
end
