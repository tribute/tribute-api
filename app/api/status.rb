module Tribute
  module Api
    class Status < Grape::API
      format :json
      namespace :status do
      	get "system" do
          {
            status:
            {
              id: "system",
              message: "ok"
            }
          }
    	 end
      end
    end
  end
end
