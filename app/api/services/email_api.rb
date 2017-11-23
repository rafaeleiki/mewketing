require 'net/smtp'

module Services
  class EmailAPI < Grape::API
    version 'v1', using: :header, vendor: 'email'
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
        params.except(:sender_email, :sender_pass, :groups, :template).each_pair do |key, value|
          @q_params[key] = value unless value.nil?
        end
      end

      def get_groups(group_names)
        groups = []
        group_names.each do |group|
          g = Group.active.find_by(name: group)
          error!("One group could not be found")  if g.nil?
          groups << g
        end
        return groups
      end
    end

    # API call souvers
    resource :email do
      # CRUD - DB Management
      desc 'Schedule a new email with custom body'
      params do
        use :credentials
        requires :schedule, type: DateTime, desc: 'Schedule date of the new email'
        requires :title, type: String, desc: 'Title of the new email'
        requires :body, type: String, desc: 'Body of the new email'
        requires :groups, type: [String], desc: 'Name of the groups to send the email'
      end
      post :schedule_manually do
        groups = get_groups(params[:groups])
        error!("No group passed") if groups.size == 0

        @q_params[:sent] = params[:schedule] <= Time.new
        e = Email.create(@q_params)
        error!("Internal error") if e.nil?

        groups.each do |g|
          EmailGroup.create(email: e, group: g)
        end

        if e.sent
          e.send_email
          return {"status":"Email sent"}
        else
          return {"status":"Email scheduled"}
        end
      end

      desc 'Schedule a new email with template'
      params do
        use :credentials
        requires :schedule, type: DateTime, desc: 'Schedule date of the new email'
        requires :title, type: String, desc: 'Title of the new email'
        requires :template, type: String, desc: 'Template of the new email'
        requires :vars, type: Hash, desc: 'Variables to fill the template'
        requires :groups, type:  [String], desc: 'Name of the groups to send the email'
      end
      post :schedule_template do
        t = Template.find_by(title: params[:template])
        error!("Template not found") if t.nil?

        groups = get_groups(params[:groups])
        error!("No group passed") if groups.size == 0

        @q_params[:sent] = params[:schedule] <= Time.new
        @q_params[:body] = t.body
        e = Email.create(@q_params)
        error!("Internal error") if e.nil?

        groups.each do |g|
          EmailGroup.create(email: e, group: g)
        end

        if e.sent
          e.send_email
          return {"status":"Email sent"}
        else
          return {"status":"Email scheduled"}
        end
      end

      desc 'Read some emails'
      params do
        use :credentials
        optional :schedule, type: DateTime, desc: 'Schedule date of a email'
        optional :title, type: String, desc: 'Title of a email'
      end
      post :get do
        Email.active.where(@q_params)
      end

      desc 'Read all emails'
      params do
        use :credentials
      end
      post :get_all do
        Email.active.where(sender: @user).all
      end

      desc 'Remove one email from schedule'
      params do
        use :credentials
        requires :schedule, type: DateTime, desc: 'Schedule of the wanted email'
        requires :title, type: String, desc: 'Title of the wanted email'
      end
      post :remove do
        e = Email.active.not_sent.find_by(@q_params)
        error!("Email not found") if e.nil?
        error!("Internal error") if !e.destroy
        return {"status":"Email removed"}
      end
    end
  end
end
