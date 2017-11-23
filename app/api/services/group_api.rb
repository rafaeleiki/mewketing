module Services
  class GroupAPI < Grape::API
    version 'v1', using: :header, vendor: 'group'
    content_type :json, 'application/json;charset=utf-8'

    # Actions to be performed before all api responses
    before {
      authorize(params[:sender_email], params[:sender_password])
      get_params(params)
    }

    # Helpers
    helpers do
      params :credentials do
        requires :sender_email, type: String, desc: 'Sender email for authentication'
        requires :sender_password, type: String, desc: 'Sender pass for authentication'
      end

      def authorize(email, pass)
        @user = Sender.active.find_by_email(email)
        error!("Unauthorized") if !(@user && @user.authenticate(pass))
      end

      def get_params(params)
        @q_params = {sender: @user}
        params.except(:sender_email, :sender_password, :original_name).each_pair do |key, value|
          @q_params[key] = value unless value.nil?
        end
      end
    end

    # API call souvers
    resource :group do
      # CRUD - DB Management
      desc 'Add a new group'
      params do
        use :credentials
        requires :name, type: String, desc: 'Name of the new group'
        requires :private, type: Boolean, desc: 'Name of the new group'
      end
      post :add do
        g = Group.active.find_by(sender: @user, name: params[:name])
        error!("Group already created") if !g.nil?
        g = Group.create(@q_params)
        error!("Internal error") if g.nil?
        return {"status":"Group created"}
      end

      desc 'Read some group'
      params do
        use :credentials
        optional :name, type: String, desc: 'Name of the new group'
        optional :private, type: Boolean, desc: 'Name of the new group'
      end
      post :get do
        Group.active.where(@q_params)
      end

      desc 'Read all groups'
      params do
        use :credentials
      end
      post :get_all do
        Group.active.where(sender: @user).all
      end

      desc 'Update one group'
      params do
        use :credentials
        requires :original_name, type: String, desc: 'Name of the group'
        optional :name, type: String, desc: 'Name of the group'
        optional :private, type: Boolean, desc: 'Name of the group'
      end
      post :update do
        g = Group.active.find_by(sender: @user, name: params[:original_name])
        error!("Group not found") if g.nil?
        gn = Group.active.find_by(sender: @user, name: params[:name])
        error!("There is already a group with this name") if !gn.nil?
        g.update(@q_params)
        return {"status":"Group updated"}
      end

      desc 'Remove one '
      params do
        use :credentials
        requires :name, type: String, desc: 'Name of the new group'
      end
      post :remove do
        g = Group.active.find_by(@q_params)
        error!("Group not found") if g.nil?
        error!("Internal error") if !g.destroy
        return {"status":"Group removed"}
      end

      # Receivers management
      desc 'Add a receiver to a group'
      params do
        use :credentials, desc: "Credentials"
        requires :group_name, type: String, desc: 'Name of the group to add the receiver'
        requires :receiver_email, type: String, desc: 'Email of the receiver to be added'
      end
      post :add_receiver do
        g = Group.active.find_by(name: params[:group_name])
        r = Receiver.active.find_by(email: params[:receiver_email])
        error!("Group not found") if g.nil?
        error!("Receiver not found") if r.nil?
        error!("Receiver already in group") if !GroupReceiver.find_by(group: g, receiver: r).nil?
        gr = GroupReceiver.create(group: g, receiver: r)
        error!("Internal error") if gr.nil?
        return {"status":"Receiver added to group"}
      end

      desc 'Remove a receiver from a group'
      params do
        use :credentials, desc: "Credentials"
        requires :group_name, type: String, desc: 'Name of the group'
        requires :receiver_email, type: String, desc: 'Email of the receiver to be removed'
      end
      post :remove_receiver do
        g = Group.active.find_by(name: params[:group_name])
        r = Receiver.active.find_by(email: params[:receiver_email])
        error!("Group not found") if g.nil?
        error!("Receiver not found") if r.nil?
        gr = GroupReceiver.find_by(group: g, receiver: r)
        error!("Receiver not inside group") if gr.nil?
        error!("Internal error") if !gr.destroy
        return {"status":"Receiver removed from group"}
      end
    end
  end
end
