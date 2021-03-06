class ReceiversController < ApplicationController

  before_action :authorize
  before_action :set_receiver, only: [:show, :edit, :update, :destroy, :add_to_group_show]
  before_action :verify_receiver, only: [:show, :edit, :update, :destroy, :add_to_group_show]

  # GET /receivers
  # GET /receivers.json
  def index
    @receivers = current_user.client.receivers.active
  end

  def add_to_group_show
      @groups = current_user.groups
  end

  def add_to_group_update
    @group_receivers = GroupReceiver.new(params)
  end

  # GET /receivers/1
  # GET /receivers/1.json
  def show
  end

  # GET /receivers/new
  def new
    @receiver = Receiver.new
  end

  # GET /receivers/1/edit
  def edit
  end

  # POST /receivers
  # POST /receivers.json
  def create
    @receiver = Receiver.new(receiver_params)
    @receiver.sender = current_user
    @group = Group.new
    @group.sender = current_user
    @group.name = @receiver.name
    @group.private = true
    @group_receivers = GroupReceiver.new
    @group_receivers.group = @group
    @group_receivers.receiver = @receiver

    @group.save
    @group_receivers.save

    respond_to do |format|
      if @receiver.save
        format.html { redirect_to @receiver, notice: 'Receiver was successfully created.' }
        format.json { render :show, status: :created, location: @receiver }
      else
        format.html { render :new }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receivers/1
  # PATCH/PUT /receivers/1.json
  def update
    respond_to do |format|
      if @receiver.update(receiver_params)
        format.html { redirect_to @receiver, notice: 'Receiver was successfully updated.' }
        format.json { render :show, status: :ok, location: @receiver }
      else
        format.html { render :edit }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivers/1
  # DELETE /receivers/1.json
  def destroy
    @receiver.destroy
    respond_to do |format|
      format.html { redirect_to receivers_url, notice: 'Receiver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receiver
      @receiver = Receiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receiver_params
      params.require(:receiver).permit(:name, :email, :sender_id)
    end

    def verify_receiver
      redirect_to '/receivers/access_denied' if current_user.client != @receiver.client
    end
end
