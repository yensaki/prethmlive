module Prethmlive
  class Response
    def initialize(oauth_response)
      @raw = oauth_response
    end

    def parsed
      JSON.parse(@raw.body).with_indifferent_access
    end
  end
end
