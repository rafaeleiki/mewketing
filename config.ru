# This file is used by Rack-based servers to start the application.
require "rack/cors"

require_relative 'config/environment'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options, :put]
  end
end

# run API::Services
run Rails.application
