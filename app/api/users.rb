module Tribute
  module Api
    class User < Grape::API
      format :json

      namespace :users do

        desc "Retrieve a user by id."
        get "/:user_id" do
          authenticated_user
          if ! params[:user_id] || (params[:user_id] == 'current')
            user = current_user
          else
            user = Tribute::Models::User.find(params[:user_id])
            error! "Not Found", 404 unless user
          end
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
