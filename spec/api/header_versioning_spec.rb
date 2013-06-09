require 'spec_helper'

describe Tribute::API do
  include Rack::Test::Methods

  def app
    Tribute::API
  end

  context "header based versioning" do
    it "vendored header" do
      get "/", nil, { "HTTP_ACCEPT" => "application/vnd.tribute-v1+json" }
      last_response.status.should == 200
      JSON.parse(last_response.body)["status_url"].should_not be_blank
    end
    it "invalid version" do
      get "/", nil, { "HTTP_ACCEPT" => "application/vnd.tribute-v2+json" }
      last_response.status.should == 404
    end
  end

end

