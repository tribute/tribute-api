module Tribute
  module Api
    class Users < Grape::API
      format :json

      desc "Current user."
      get '/user' do
        authenticated_user
        {
          user: {
            id: current_user._id,
            provider: current_user.provider,
            uid: current_user.uid,
          }
        }
      end

      namespace :users do

        desc "Retrieve a user by id."
        params do
          requires :user_id
        end
        get "/:user_id" do
          authenticated_user
          user = Tribute::Models::User.find(params[:user_id])
          error!("Not Found", 404) unless user
          {
            user: {
              id: user._id,
              provider: user.provider,
              uid: user.uid
            }
          }
        end

      end

    end
  end
end
