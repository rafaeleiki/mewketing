# Actions to be performed before all api responses
before {
  authorize(params[:sender_email], params[:sender_pass])
}

# Helpers
helpers do
  params :credentials do
    requires :sender_email, type: String, desc: 'Sender email for authentication'
    requires :sender_pass, type: String, desc: 'Sender pass for authentication'
  end

  def authorize(email, pass)
    @user = Sender.find_by_email(email)
    error!("Unauthorized") if !(@user && @user.authenticate(pass))
  end
end

resource : do
  # CRUD - DB Management
  desc 'Add a new '
  params do
    use :credentials
    requires , type: , desc: '  of '
  end
  post :add do
    error!("Record already created") if !(.find_by(: params[:]).nil?)
    .create(: params[:])
  end

  desc 'Read some  by selecting '
  params do
    use :credentials
    requires , type: , desc: '  of '
  end
  post :add do
    .find_by(params)
  end

  desc 'Read all '
  params do
    use :credentials
    requires , type: , desc: '  of '
  end
  post :add do
    if .find_by(: params[:]).nil?
      .create(: params[:])
    end
  end

  desc 'Update one '
  params do
    use :credentials
    requires , type: , desc: '  of '
  end
  post :add do
    if .find_by(: params[:]).nil?
      .create(: params[:])
    end
  end

  desc 'Remove one '
  params do
    use :credentials
    requires , type: , desc: '  of '
  end
  post :add do
    if .find_by(: params[:]).nil?
      .create(: params[:])
    end
  end
end
