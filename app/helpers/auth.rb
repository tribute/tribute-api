module Tribute
  module Helpers
    module Auth
      def warden
        env['warden']
      end
      def authenticated
        error!('Unauthorized', 401) unless warden.authenticated?
      end
      def current_user
        warden.user
      end
      # returns 403 if there's no current user
      def authenticated_user
        authenticated
        error!('Forbidden', 403) unless current_user
      end
    end
  end
end
