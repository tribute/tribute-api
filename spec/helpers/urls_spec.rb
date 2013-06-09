require 'spec_helper'

describe Tribute::Helpers::Urls do
  subject do
    Class.new do
      include Tribute::Helpers::Urls
      def transform(relative_url)
        url(relative_url)
      end
      def request
        Rack::Request.new(ENV)
      end
    end.new
  end
  context "#url" do
    before :each do
      ENV["rack.url_scheme"] = 'http'
      ENV['HTTP_HOST'] = 'test.host.local'
      ENV['SERVER_PORT'] = '80'
    end
    it "nil" do
      subject.transform(nil).should be_nil
    end
    it "/" do
      subject.transform("").should eq 'http://test.host.local'
    end
    it "prepends /" do
      subject.transform("foo").should eq 'http://test.host.local/foo'
    end
    it "doesn't prepend /" do
      subject.transform("/foo").should eq 'http://test.host.local/foo'
    end
    after :each do
      ENV['HTTP_HOST'] = nil
      ENV["rack.url_scheme"] = nil
      ENV['SERVER_PORT'] = nil
    end
  end
end

