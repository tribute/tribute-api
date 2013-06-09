require 'spec_helper'

describe Tribute::Api::User do
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
    before do
      @user = Fabricate(:user)
    end
    it "returns self" do
      login_as @user
      get "/users/#{@user.id}"
      last_response.status.should == 200
      json = JSON.parse(last_response.body)
      json["_id"].should == @user.id.to_s
      json["provider"].should == "github"
      json["uid"].should == @user.uid.to_s
    end
    it "does not return other users" do
      login_as Fabricate(:user)
      get "/users/#{@user.id}"
      last_response.status.should == 403
      last_response.body.should == { error: "Forbidden" }.to_json
    end
  end

end

