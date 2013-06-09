module Tribute
  class Auth < Grape::API
    format :json
    %w(get post).each do |method|
      desc "Authentication callback."
      send method, "/auth/:provider/callback" do
        env['omniauth.auth']
      end
    end
    desc "Authentication failure callback."
    get "/auth/failure" do
      error! "Unauthorized (Omniauth)", 401
    end
  end
end
