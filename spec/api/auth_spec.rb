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

  context "logged in" do
    let(:user) { Fabricate(:user) }
    before :each do
      login_as user
    end
    it "get /auth/developer/callback/iframe" do
      get "/auth/developer/callback/iframe"
      last_response.status.should == 200
      last_response.body.should include "'user': '#{user.id}'"
    end
  end

  it "get /auth/developer/callback" do
    get "/auth/developer/callback"
    last_response.status.should == 200
    last_response.body.should include "window.addEventListener"
  end

end

