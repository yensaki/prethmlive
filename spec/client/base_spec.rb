require 'prethmlive'

RSpec.describe Prethmlive::Client::Base do
  class TestClient < Prethmlive::Client::Base
    def client_configuration
      ['consumerkey', 'consumer_secret', { site_id: 'http://example.com' }]
    end
  end

  context '#credentials' do
    let(:token) { 'aaa' }
    let(:refresh_token) { 'bbb' }
    it 'returns' do
      expires_at =  Time.now + 3600
      client = TestClient.new(token: token, refresh_token: refresh_token, expires_at: expires_at)
      expect(client.credentials).to eq({ token: token, refresh_token: refresh_token, expires_at: expires_at.to_i })
    end
  end
end