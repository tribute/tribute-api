# Mostly copied from authorization in Travis CI
module Tribute
  module Api
    class Auth < Grape::API
      format :json

      content_type :html, "text/html"
      formatter :html, nil

      %w(get post).each do |method|
        desc "Authentication callback."
        send method, "/auth/:provider/callback" do
          auth = env['omniauth.auth']
          auth_token = auth[:credentials][:token] || SecureRandom.hex(16)
          if (user = Tribute::Models::User.where(provider: auth[:provider], uid: auth[:uid]).first)
            user.update_attributes!(token: auth_token) if user.auth_token != auth_token
          else
            user = Tribute::Models::User.create!(provider: auth[:provider], uid: auth[:uid], token: auth_token)
          end
          warden.set_user user
          redirect params[:redirect_uri] || request.env['omniauth.params']['redirect_uri']
        end
      end

      # Endpoint for making sure user authorized Tribute to access GitHub.
      # There are no restrictions on where to redirect to after handshake.
      # However, no information whatsoever is being sent with the redirect.
      #
      # Parameters:
      #
      # * **redirect_uri**: URI to redirect to after handshake.
      get "/auth/:provider/handshake" do
        if ! warden.authenticated?
          redirect "/auth/#{params[:provider]}?redirect_uri=#{params[:redirect_uri]}"
        else
          content_type "text/html"
          erb "auth/post_payload.erb", {
            user: current_user,
            redirect_uri: params[:redirect_uri] || request.env['omniauth.params']['redirect_uri']
          }
        end
      end

      get "/auth/:provider/post_message/iframe" do
        if ! warden.authenticated?
          redirect "/auth/#{params[:provider]}?redirect_uri=#{params[:redirect_uri]}"
        else
          content_type "text/html"
          erb "auth/post_message.erb", { user: current_user, redirect_uri: params[:redirect_uri] }
        end
      end

      # This endpoint is meant to be embedded in an iframe, popup window or
      # similar. It will perform the handshake and, once done, will send an
      # access token and user payload to the parent window via postMessage.
      #
      # Example usage:
      #
      #     window.addEventListener("message", function(event) {
      #       console.log("received token: " + event.data.token);
      #     });
      #
      #     var iframe = $('<iframe />').hide();
      #     iframe.appendTo('body');
      #     iframe.attr('src', "https://api.travis-ci.org/auth/post_message");
      #
      # Note that embedding it in an iframe will only work for users that are
      # logged in at GitHub and already authorized Tribute. It is therefore
      # recommended to redirect to [/auth/handshake](#/auth/handshake) if no
      # token is being received.
      get "/auth/:provider/post_message" do
        content_type "text/html"
        erb "auth/container.erb"
      end

    end
  end
end

