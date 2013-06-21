require File.expand_path('../config/environment', __FILE__)

instance = Tribute::App.instance

NewRelic::Agent.manual_start

run instance
