require File.expand_path('../config/environment', __FILE__)

instance = Tribute::App.instance

NewRelic::Agent.manual_start

require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

run instance
