require 'spec_helper'

describe Tribute::Api::Users do
  include Rack::Test::Methods

  def app
    Tribute::App.instance
  end

  it "returns access denied" do
    get "/users/123"
    last_response.status.should == 401
    last_response.body.should == { error: "Unauthorized" }.to_json
  end

  context "with a user" do
    let(:user) { Fabricate(:user) }
    it "returns self" do
      login_as user
      get "/users/#{user.id}"
      last_response.status.should == 200
      json = JSON.parse(last_response.body)
      json["user"]["id"].should == user.id.to_s
      json["user"]["provider"].should == "github"
      json["user"]["uid"].should == user.uid.to_s
    end
    it "returns other users" do
      user2 = Fabricate(:user)
      login_as user
      get "/users/#{user2.id}"
      last_response.status.should == 200
      json = JSON.parse(last_response.body)
      json["user"]["id"].should == user2.id.to_s
    end
  end

end

