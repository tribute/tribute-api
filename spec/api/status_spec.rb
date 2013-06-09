require 'spec_helper'

describe Tribute::API do
  include Rack::Test::Methods

  def app
    Tribute::API
  end

  it "status" do
    get "/status"
    last_response.status.should == 200
    last_response.body.should == { :status => "ok" }.to_json
  end

end

