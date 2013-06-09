ENV['RACK_ENV'] ||= :test

require File.expand_path('../application', __FILE__)

Mongoid.load! "config/mongoid.yml", ENV['RACK_ENV']


