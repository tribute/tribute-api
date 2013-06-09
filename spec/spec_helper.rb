require 'rubygems'

ENV["RACK_ENV"] ||= 'test'

require 'rack/test'

require File.expand_path("../../config/environment", __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end

[ "support/*.rb" ].each do |path|
  Dir["#{File.dirname(__FILE__)}/#{path}"].each do |file|
    require file
  end
end
