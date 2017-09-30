class SendersController < ApplicationController
  before_action :authorize
  before_action :authorize_admin, only: [:new, :create, :destroy]
  before_action :set_sender, only: [:show, :edit, :update, :destroy]

  # GET /senders
  # GET /senders.json
  def index
    @senders = current_user.client.senders
  end

  # GET /senders/1
  # GET /senders/1.json
  def show
    redirect_to '/senders/not_client' unless @sender.client == current_user.client
  end

  # GET /senders/new
  def new
    @sender = Sender.new
  end

  # GET /senders/1/edit
  def edit
    if !current_user.admin
      if @sender.id != current_user.id
        redirect_to '/senders/not_user'
      end
    end
  end

  # POST /senders
  # POST /senders.json
  def create
    create_params = sender_params
    create_obj = sender_params.except(:confirm_password)
    create_obj[:client_id] = current_user.client_id
    create_obj[:admin] = false
    @sender = Sender.new(create_obj)
    @sender.validate_new_password(nil, create_params[:password], create_params[:confirm_password])

    respond_to do |format|
      if @sender.errors.empty? && @sender.save
        format.html { redirect_to @sender, notice: 'Sender was successfully created.' }
        format.json { render :show, status: :created, location: @sender }
      else
        format.html { render :new }
        format.json { render json: @sender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /senders/1
  # PATCH/PUT /senders/1.json
  def update
    def edit
      if !current_user.admin
        if @sender.id != current_user.id
          redirect_to '/senders/not_user'
        end
      end
    end
    update_params = sender_edit_params
    @sender.validate_new_password(update_params[:old_password],
                                  update_params[:new_password],
                                  update_params[:confirm_password])

    update_object = update_params.except(:new_password, :old_password, :confirm_password)
    update_object[:password] = update_params[:new_password]

    respond_to do |format|
      if @sender.errors.empty? && @sender.update(update_object)

        format.html { redirect_to @sender, notice: 'Sender was successfully updated.' }
        format.json { render :show, status: :ok, location: @sender }
      else
        format.html { render :edit }
        format.json { render json: @sender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /senders/1
  # DELETE /senders/1.json
  def destroy
    @sender.destroy
    respond_to do |format|
      format.html { redirect_to senders_url, notice: 'Sender was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def not_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sender
      @sender = Sender.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sender_params
      params.require(:sender).permit(:email, :password, :confirm_password, :admin, :client_id)
    end

    def sender_edit_params
      params.require(:sender).permit(:email, :new_password, :old_password,
                                     :confirm_password, :admin, :client_id)
    end
end
