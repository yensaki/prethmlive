module Prethmlive
  class Response
    def initialize(oauth_response)
      @raw = oauth_response
    end

    def parsed
      JSON.parse(@raw.body)
    end
  end
end
