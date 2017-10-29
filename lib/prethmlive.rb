require "prethmlive/version"
require "prethmlive/client"

module Prethmlive
  @provider_configs = {}

  def self.setup
    yield self
  end

  def oauth2_client(provider_sym, client_id, client_secret, site)
    @provider_configs[provider_sym] = Prethmlive::Client::Config.new(client_id, client_secret, site)
  end
end
