module Services
  class SenderAPI < Grape::API
    version 'v1', using: :header, vendor: 'sender'
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
        @q_params = {client: @user.client}
        params.except(:sender_email, :sender_password, :original_email, :password).each_pair do |key, value|
          @q_params[key] = value unless value.nil?
        end
      end
    end

    # API call souvers
    resource :sender do
      # CRUD - DB Management
      desc 'Add a new sender'
      params do
        use :credentials
        requires :email, type: String, desc: 'Email of the new sender'
        requires :password, type: String, desc: 'Password of the new sender'
      end
      post :add do
        error!("Unauthorized") if !@user.admin
        s = Sender.active.find_by(@q_params)
        error!("Sender already created") if !s.nil?
        @q_params[:admin] = false
        @q_params[:password] = params[:password]
        s = Sender.new(@q_params)
        error!("Internal error") if !s.save
        return {"status":"Sender created"}
      end

      desc 'Read some senders'
      params do
        use :credentials
        optional :email, type: String, desc: 'Email of the a sender'
        optional :admin, type: Boolean, desc: 'Admin condition of a sender'
      end
      post :get do
        Sender.active.where(@q_params)
      end

      desc 'Read all senders'
      params do
        use :credentials
      end
      post :get_all do
        Sender.active.where(client: @user.client).all
      end

      desc 'Update one sender'
      params do
        use :credentials
        requires :original_email, type: String, desc: 'Original email of the sender'
        optional :email, type: String, desc: 'Email of the sender'
        optional :password, type: String, default: "", desc: 'Password of the sender'
      end
      post :update do
        s = Sender.active.find_by(client: @user.client, email: params[:original_email])
        error!("Sender not found") if s.nil?
        error!("Unauthorized") if !(@user.admin || @user == s)
        sn = Sender.active.find_by(client: @user.client, email: params[:email])
        error!("There is already a sender with this email") if !sn.nil?
        @q_params[:password] = params[:password] if params[:password] != ""
        s.update(@q_params)
        return {"status":"Sender updated"}
      end

      desc 'Remove one '
      params do
        use :credentials
        requires :email, type: String, desc: 'Email of the sender'
      end
      post :remove do
        error!("Unauthorized") if !@user.admin
        s = Sender.active.find_by(@q_params)
        error!("Sender not found") if s.nil?
        error!("Internal error") if !s.destroy
        return {"status":"Sender removed"}
      end
    end
  end
end
