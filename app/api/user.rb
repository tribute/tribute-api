module Tribute
  module Api
    class User < Grape::API
      format :json
      get "/user" do
        authenticated_user
        current_user.as_json
      end
    end
  end
end