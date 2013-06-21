module Tribute
  module Api
    class Status < Grape::API
      format :json
      get "/status" do
        { :status => "ok" }
      end
    end
  end
end