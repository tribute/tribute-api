require 'erb'

current_dir = File.dirname(__FILE__)

[ 'app', 'app/api', 'app/helpers', 'app/models' ].each do |path|
  $LOAD_PATH.unshift(File.join(current_dir, '..', path))
end

$LOAD_PATH.unshift(current_dir)

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

[ 'app/helpers', 'app/models', 'app/api' ].each do |path|
  Dir[File.expand_path("../../#{path}/*.rb", __FILE__)].each do |f|
    require f
  end
end

require 'api'
require 'app'