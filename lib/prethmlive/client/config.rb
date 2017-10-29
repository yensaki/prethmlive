module Prethmlive
  class Client
    class Config
      attr_reader :client_id, :client_secret, :site

      def initialize(client_id, client_secret, site, &block)
        @client_id = client_id
        @client_secret = client_secret
        @site = site
        yield if block_given?
      end

      def default_options
        { headers: default_headers }
      end

      def default_headers
        {}
      end

      def client_configuration(opts = {})
        [client_id, client_secret, opts.merge(site: site)]
      end

      def url_prefix
        File.join(site, path_prefix)
      end
    end
  end
end
