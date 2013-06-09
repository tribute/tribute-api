require 'spec_helper'

describe Tribute::Api::User do
  include Rack::Test::Methods

  def app
    Tribute::App.instance
  end

  it "returns access denied" do
    get "/user"
    last_response.status.should == 401
    last_response.body.should == { error: "Unauthorized" }.to_json
  end

  it "returns user" do
    login_as Fabricate(:user)
    get "/user"
    last_response.status.should == 200
    json = JSON.parse(last_response.body)
    json["provider"].should == "github"
    json["uid"].should_not be_nil
  end

end

