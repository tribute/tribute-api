require 'spec_helper'

describe Tribute::API do
  include Rack::Test::Methods

  def app
    Tribute::API
  end

  it "swagger documentation" do
    get "/swagger_doc"
    last_response.status.should == 200
    json_response = JSON.parse(last_response.body)
    json_response["apiVersion"].should == "v1"
    json_response["apis"].size.should > 1
  end

end

