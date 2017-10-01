class API < Grape::API

  prefix 'api'
  format :json
  mount Services::EmailAPI
  mount Services::GroupAPI
  mount Services::SenderAPI
  mount Services::ReceiverAPI
end
