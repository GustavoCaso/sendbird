require 'faraday'

module SendbirdApi
  module Client
    class ApiKeyMissingError < StandardError; end
    PUBLIC_METHODS = [:get, :post, :put, :delete]

    PUBLIC_METHODS.each do |method|
      define_method(method) do |path: , params: nil , body: nil|
        fail ApiKeyMissingError.new(api_key_message) if SendbirdApi.api_key.nil?
        response = request(method: method, path: path, params: params, body: body)
        Response.new(response.status, response.body)
      end
    end

    private
    def conn
      Faraday.new(url: SendbirdApi::Configuration::SENDBIRD_ENDPOINT) do |c|
        c.request  :url_encoded
        c.adapter  Faraday.default_adapter
      end
    end

    def request(method:, path:, params:, body:)
      conn.send(method) do |req|
        req.url path, params
        req.headers['Api-Token'] = SendbirdApi.api_key
        req.headers['Content-Type'] = 'application/json, charset=utf8'
        req.body = body.to_json if body
      end
    end

    def api_key_message
      'Please set up your api key'
    end
  end
end
