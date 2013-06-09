module Tribute
  module Api
    class User < Grape::API
      format :json
      namespace :users do
        get "/:user_id" do
          authenticated_user
          # TODO: enable retrieving other users
          error! "Forbidden",403 if current_user.id.to_s != params[:user_id]
          current_user.as_json
        end
      end
    end
  end
end