module Tribute
  module Api
    class Auth < Grape::API
      format :json
      %w(get post).each do |method|
        desc "Authentication callback."
        send method, "/auth/:provider/callback" do
          auth = env['omniauth.auth']
          user = Tribute::Models::User.where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize
          warden.set_user user
          auth
        end
      end
      desc "Authentication failure callback."
      get "/auth/failure" do
        error! "Unauthorized (Omniauth)", 401
      end
    end
  end
end
