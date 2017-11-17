class GroupsController < ApplicationController

  before_action :authorize
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.client.groups.active
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    redirect_to '/groups/not_group' unless @group.sender.client == current_user.client
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.sender = current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def receivers
    @group = Group.find(params[:id]) if params[:id] != 'null'
    query = params[:query]
    receivers = get_receivers_from_group
    receivers_ids = receivers.map { |receiver| receiver[:receiver_id] }
    searched_receivers = get_searched_receivers(query, receivers_ids)
    render json: { data: receivers + searched_receivers }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :private, :sender_id,
                                    group_receivers_attributes: group_receivers_params)
    end

    def group_receivers_params
      [:id, :receiver_id, :_destroy]
    end

    def get_receivers_from_group
      if @group.nil?
        []
      else
        @group.group_receivers.map { |relation| {
            id: relation.id,
            receiver_id: relation.receiver_id,
            title: relation.receiver.email
        }}
      end
    end

    def get_searched_receivers(query, receiver_ids)
      if receiver_ids.nil? || receiver_ids.empty?
        searched_receivers = Receiver.active.where('email LIKE ?', "%#{query}%")
      else
        searched_receivers = Receiver.active.where('email LIKE ? AND id NOT IN (?)', "%#{query}%", receiver_ids)
      end

      searched_receivers.map { |receiver| {
          receiver_id: receiver.id,
          title: receiver.email
      }}
    end
end
