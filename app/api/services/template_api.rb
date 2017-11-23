module Services
  class TemplateAPI < Grape::API
    version 'v1', using: :header, vendor: 'template'
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
        puts ("Senha:" + pass)
        @user = Sender.active.find_by_email(email)
        error!("Unauthorized") if !(@user && @user.authenticate(pass))
      end

      def get_params(params)
        @q_params = {sender: @user}
        params.except(:sender_email, :sender_password, :original_title).each_pair do |key, value|
          @q_params[key] = value unless value.nil?
        end
      end
    end

    # API call souvers
    resource :template do
      # CRUD - DB Management
      desc 'Add a new template'
      params do
        use :credentials
        requires :title, type: String, desc: 'Title of the new template'
        requires :body, type: String, desc: 'Body of the new template'
      end
      post :add do
        t = Template.find_by(sender: @user, title: params[:title])
        error!("Template already created") if !t.nil?
        t = Template.create(@q_params)
        error!("Internal error") if t.nil?
        return {"status":"Template created"}
      end

      desc 'Read some templates'
      params do
        use :credentials
        optional :title, type: String, desc: 'Title of the template'
      end
      post :get do
        Template.where(@q_params)
      end

      desc 'Read all templates'
      params do
        use :credentials
      end
      post :get_all do
        Template.where(sender: @user).all
      end

      desc 'Update one template'
      params do
        use :credentials
        requires :original_title, type: String, desc: 'Original title of the template'
        optional :title, type: String, desc: 'Title of the template'
        optional :body, type: String, desc: 'Body of the template'
      end
      post :update do
        t = Template.find_by(sender: @user, title: params[:original_title])
        error!("Template not found") if t.nil?
        rn = Template.find_by(sender: @user, title: params[:title])
        error!("There is already a template with this title") if !rn.nil?
        t.update(@q_params)
        return {"status":"Template updated"}
      end

      desc 'Remove one '
      params do
        use :credentials
        requires :title, type: String, desc: 'Title of the template'
      end
      post :remove do
        g = Template.find_by(@q_params)
        error!("Template not found") if g.nil?
        error!("Internal error") if !g.destroy
        return {"status":"Template removed"}
      end
    end
  end
end
