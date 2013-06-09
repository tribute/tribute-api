module Tribute
  module Api
    class User < Grape::API
      format :json
      
      namespace :users do
        
        desc "Retrieve a user by id."
        get "/:user_id" do
          authenticated_user
          user = Tribute::Models::User.find(params[:user_id])
          error! "Not Found", 404 unless user
          user.as_json
        end

      end

      desc "Retrieve current user."
      get :user do
        authenticated_user
        current_user.as_json
      end
      
    end
  end
end