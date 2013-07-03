module Tribute
  module Api
    class Auth < Grape::API
      format :json

      content_type :html, "text/html"
      formatter :html, nil

      get "/auth/handshake" do
        authenticated_user
        content_type "text/html"
        erb "auth/form.erb", { 
          user: current_user, 
          redirect_uri: params[:redirect_uri] || request.env['omniauth.params']['redirect_uri']
        }
      end

      get "/auth/:provider/callback/iframe" do
        authenticated_user
        content_type "text/html"
        erb "auth/payload.erb", user: current_user
      end

      get "/auth/:provider/frame" do
        content_type "text/html"
        erb "auth/iframe.erb"
      end

      %w(get post).each do |method|
        desc "Authentication callback."
        send method, "/auth/:provider/callback" do
          auth = env['omniauth.auth']
          user = Tribute::Models::User.where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize
          warden.set_user user
        end
      end

      desc "Authentication failure callback."
      get "/auth/failure" do
        error! "Unauthorized (Omniauth)", 401
      end

    end
  end
end

