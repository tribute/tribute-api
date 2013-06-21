require 'spec_helper'

describe Tribute::API do
  include Rack::Test::Methods

  def app
    Tribute::App.instance
  end

  context "CORS" do
    it "includes Access-Control-Allow-Origin in the response" do
      get "/", {}, "HTTP_ORIGIN" => "http://cors.example.com"
      last_response.status.should == 200
      last_response.headers['Access-Control-Allow-Origin'].should == "http://cors.example.com"
    end
    it "includes Access-Control-Allow-Origin in errors" do
      get "/invalid", {}, "HTTP_ORIGIN" => "http://cors.example.com"
      last_response.status.should == 404
      last_response.headers['Access-Control-Allow-Origin'].should == "http://cors.example.com"
    end
  end

end

