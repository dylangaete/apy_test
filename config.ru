require_relative "config/environment"

use Rack::Cors do
  allow do
    origins "http://localhost:3000" # Reemplaza esto con el origen correcto de tu aplicación React
    resource "*", headers: :any, methods: [:get, :post, :options]
  end
end

run Rails.application
