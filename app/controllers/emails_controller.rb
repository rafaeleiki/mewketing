class EmailsController < ApplicationController

  before_action :authorize
  before_action :set_email, only: [:show, :edit, :update, :destroy]
  before_action :set_templates, only: [:new, :edit, :create, :update]

  # GET /emails
  # GET /emails.json
  def index
    @emails = current_user.client.emails
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)
    @email.sender = current_user
    @email.sent = @email.schedule <= Time.new

    respond_to do |format|
      if @email.save
        @email.send_email if @email.sent
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    update_object = email_params
    vp = vars_params
    update_object[:vars] = {
        vars: vp[:vars],
        values: vp[:values]
    }

    respond_to do |format|
      if @email.update(update_object)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def groups
    @email = Email.find(params[:id]) if params[:id] != 'null'
    query = params[:query]
    groups = get_groups_from_email
    groups_ids = groups.map { |group| group[:group_id] }
    searched_groups = get_searched_groups(query, groups_ids)
    render json: { data: groups + searched_groups }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:schedule, :title, :body,
                                    email_groups_attributes: email_groups_params)
    end

    def email_groups_params
      [:id, :group_id, :_destroy]
    end

    def get_groups_from_email
      if @email.nil?
        []
      else
        @email.email_groups.map { |relation| {
            id: relation.id,
            group_id: relation.group_id,
            title: relation.group.name
        }}
      end
    end

    def get_searched_groups(query, group_ids)
      if group_ids.nil? || group_ids.empty?
        searched_groups = Group.where('name LIKE ?', "%#{query}%")
      else
        searched_groups = Group.where('name LIKE ? AND id NOT IN (?)', "%#{query}%", group_ids)
      end

      searched_groups.map { |group| {
          group_id: group.id,
          title: group.name
      }}
    end

    def vars_params
      vars = []
      params[:vars].each_pair do |key, value|
        vars << value
      end

      values = []
      params[:vars_values].each_pair do |key, value|
        values << value.permit!
      end

      {
          vars: vars,
          values: values
      }
    end

    def set_templates
      @templates = current_user.client.templates
    end

end
