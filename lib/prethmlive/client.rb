module Prethmlive
  class Client
    def initialize(token:, refresh_token: nil, expires_at: nil)
      client = OAuth2::Client.new(client_configuration)
      token_hash = { token: token, refresh_token: refresh_token, expires_at: expires_at.to_i }
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

    def default_options
      { headers: default_headers }
    end

    def default_headers
      {}
    end

    def client_configuration(opts = {})
      [client_id, client_secret, opts.merge(site: site, authorize_url: authorize_url, token_url: token_url)]
    end

    def client_id
      NotImplementedError
    end

    def client_secret
      NotImplementedError
    end

    def url_prefix
      File.join(site, path_prefix)
    end

    def site
      "#{protocol}://#{host}"
    end

    def protocol
      'https'
    end

    def host
      NotImplementedError
    end

    def path_prefix
      NotImplementedError
    end

    def authorize_url
      NotImplementedError
    end

    def token_url
      NotImplementedError
    end

    def process(request_method, relative_path, params, headers, &block)
      path = File.join(path_prefix, relative_path)
      @access_token.public_send(request_method, path, params: params, headers: headers, &block)
    end
  end
end