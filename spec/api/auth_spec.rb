require 'spec_helper'

describe Tribute::App do
  include Rack::Test::Methods

  def app
    Tribute::App.instance
  end

  it "get /auth/developer" do
    get "/auth/developer"
    last_response.status.should == 200
  end

  it "post /auth/developer/callback" do
    post "/auth/developer/callback", { name: "username", email: "email" }
    last_response.status.should == 201
    last_response.body.should == {
      provider: "developer",
      uid: "email",
      info: {
        name: "username",
        email: "email"
      },
      credentials: {},
      extra:{}
    }.to_json
  end

end

