require 'spec_helper'

describe Tribute::App do
  include Rack::Test::Methods

  def app
    Tribute::App.instance
  end

  it "get /auth/developer" do
    get "/auth/developer"
    last_response.status.should == 200
    last_response.body.should include "<button type='submit'>Sign In</button>"
  end

  it "get /auth/developer/callback" do
    expect {
      get "/auth/developer/callback?email=uid&redirect_uri=#{URI::encode('http://example.org')}"
      last_response.status.should == 302
      last_response.headers["Location"].should == "http://example.org"
    }.to change(Tribute::Models::User, :count).by(1)
  end

  context "unauthenticated" do
    it "get /auth/:provider/handshake redirects" do
      get "/auth/developer/handshake?redirect_uri=#{URI::encode('http://example.org')}"
      last_response.status.should == 302
      last_response.headers["Location"].should == "/auth/developer?redirect_uri=#{URI::encode('http://example.org')}"
    end
    it "get /auth/:provider/post_message/iframe redirects" do
      get "/auth/developer/post_message/iframe?redirect_uri=#{URI::encode('http://example.org')}"
      last_response.status.should == 302
      last_response.headers["Location"].should == "/auth/developer?redirect_uri=#{URI::encode('http://example.org')}"
    end
    it "get /auth/:provider/post_message renders container" do
      get "/auth/developer/post_message"
      last_response.status.should == 200
      last_response.headers["Content-type"].should == "text/html"
      last_response.body.should include "document.createElement('iframe')"
    end
  end

  context "authenticated" do
    let(:user) { Fabricate(:user) }
    before :each do
      login_as user
    end
    it "get /auth/:provider/handshake returns user payload" do
      get "/auth/developer/handshake?redirect_uri=#{URI::encode('http://example.org')}"
      last_response.status.should == 200
      last_response.headers["Content-type"].should == "text/html"
      last_response.body.should include "name='authToken' value='#{user.token}'"
    end
    it "get /auth/:provider/post_message/iframe returns iframe" do
      get "/auth/developer/post_message/iframe?redirect_uri=#{URI::encode('http://example.org')}"
      last_response.status.should == 200
      last_response.headers["Content-type"].should == "text/html"
      last_response.body.should include "uberParent(win).postMessage(payload, 'http://example.org');"
    end
  end

end

