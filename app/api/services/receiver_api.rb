module Services
  class ReceiverAPI < Grape::API
    version 'v1', using: :header, vendor: 'receiver'
    content_type :json, 'application/json;charset=utf-8'

    # Actions to be performed before all api responses
    before {
      authorize(params[:sender_email], params[:sender_pass])
      get_params(params)
    }

    # Helpers
    helpers do
      params :credentials do
        requires :sender_email, type: String, desc: 'Sender email for authentication'
        requires :sender_pass, type: String, desc: 'Sender pass for authentication'
      end

      def authorize(email, pass)
        @user = Sender.active.find_by_email(email)
        error!("Unauthorized") if !(@user && @user.authenticate(pass))
      end

      def get_params(params)
        @q_params = {sender: @user}
        params.except(:sender_email, :sender_pass, :original_name).each_pair do |key, value|
          @q_params[key] = value unless value.nil?
        end
      end
    end

    # API call souvers
    resource :receiver do
      # CRUD - DB Management
      desc 'Add a new receiver'
      params do
        use :credentials
        requires :name, type: String, desc: 'Name of the new receiver'
        requires :email, type: String, desc: 'Email of the new receiver'
      end
      post :add do
        r = Receiver.active.find_by(sender: @user, name: params[:name])
        error!("Receiver already created") if !r.nil?
        r = Receiver.create(@q_params)
        error!("Internal error") if r.nil?
        return {"status":"Receiver created"}
      end

      desc 'Read some receivers'
      params do
        use :credentials
        optional :name, type: String, desc: 'Name of the new receiver'
        optional :email, type: String, desc: 'Email of the new receiver'
      end
      post :get do
        Receiver.active.where(@q_params)
      end

      desc 'Read all receivers'
      params do
        use :credentials
      end
      post :get_all do
        Receiver.active.where(sender: @user).all
      end

      desc 'Update one receiver'
      params do
        use :credentials
        requires :original_name, type: String, desc: 'Original name of the receiver'
        optional :name, type: String, desc: 'Name of the receiver'
        optional :email, type: String, desc: 'Email of the receiver'
      end
      post :update do
        r = Receiver.active.find_by(sender: @user, name: params[:original_name])
        error!("Receiver not found") if r.nil?
        rn = Receiver.active.find_by(sender: @user, name: params[:name])
        error!("There is already a receiver with this name") if !rn.nil?
        r.update(@q_params)
        return {"status":"Receiver updated"}
      end

      desc 'Remove one '
      params do
        use :credentials
        requires :name, type: String, desc: 'Name of the receiver'
      end
      post :remove do
        g = Receiver.active.find_by(@q_params)
        error!("Receiver not found") if g.nil?
        error!("Internal error") if !g.destroy
        return {"status":"Receiver removed"}
      end
    end
  end
end
