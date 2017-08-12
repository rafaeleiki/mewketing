class API < Grape::API
  prefix 'api'
  format :json
  mount Services::Email

  get :a do
    {}
  end
end