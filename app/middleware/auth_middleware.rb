module Tribute
  module Api
    class AuthMiddleware < Grape::Middleware::Base

	    def warden
	      env['warden']
	    end

	    def error!(message, status = 403)
	      throw :error, message: message, status: status
	    end

	    def before
	      if access_token
	        user = Tribute::Models::User.where(token: access_token).first
	        error!('Unauthorized', 401) unless user
	        warden.set_user user
	      end
	    end

	    private

	      def access_token
	        env["HTTP_AUTHORIZATION"]
	      end

    end
  end
end
