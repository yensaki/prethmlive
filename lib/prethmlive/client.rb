require 'oauth2'

module Prethmlive
  module Client
    class Base
      def initialize(token:, refresh_token: nil, expires_at: nil)
        client = ::OAuth2::Client.new(*client_configuration)
        token_hash = { access_token: token, refresh_token: refresh_token, expires_at: expires_at.to_i }
        @access_token = OAuth2::AccessToken.from_hash(client, token_hash)
      end

      %i(get post patch put delete).each do |http_method|
        define_method http_method do |relative_path = nil, params = nil, headers = nil, &block|
          process(http_method, relative_path, params, headers, &block)
        end
      end

      def refresh!
        @access_token = @access_token.refresh!
      end

      def token_expired?
        @access_token.expired?
      end

      def credentials
        {
          token: @access_token.token,
          refresh_token: @access_token.refresh_token,
          expires_at: @access_token.expires_at
        }
      end

      private

      def process(request_method, relative_path, params, headers, &block)
        path = File.join(path_prefix, relative_path)
        @access_token.public_send(request_method, path, params: params, headers: headers, &block)
      end
    end
  end
end
