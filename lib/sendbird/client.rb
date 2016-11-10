require 'faraday'

module Sendbird
  module Client
    class ApiKeyMissingError < StandardError; end
    class HttpBasicMissing < StandardError; end

    PUBLIC_METHODS = [:get, :post, :put, :delete]

    PUBLIC_METHODS.each do |method|
      define_method(method) do |path: , params: nil , body: nil|
        fail ApiKeyMissingError.new(api_key_message) if Sendbird.api_key.nil?
        response = request(method: method, path: path, params: params, body: body)
        Response.new(response.status, response.body)
      end
    end

    PUBLIC_METHODS.each do |method|
      define_method("#{method}_http_basic") do |path: , params: nil , body: nil|
        fail HttpBasicMissing.new(http_basic_message) if sendbird_user.nil? || sendbird_password.nil?
        response = request(method: method, path: path, params: params, body: body, api_key: false, http_basic: true)
        Response.new(response.status, response.body)
      end
    end

    def build_url(*args)
      if args.any?
        new_args = args.dup
        new_args.insert(0, self.const_get('ENDPOINT')).join('/')
      else
        self.const_get('ENDPOINT')
      end
    end

    private
    def conn(http_basic)
      @conn ||= Faraday.new(url: Sendbird::Configuration::SENDBIRD_ENDPOINT) do |c|
                  c.request  :url_encoded
                  c.adapter  Faraday.default_adapter
                  if http_basic
                    c.basic_auth(sendbird_user, sendbird_password)
                  end
                end
    end

    def sendbird_user
      Sendbird.user
    end

    def sendbird_password
      Sendbird.password
    end

    def request(method:, path:, params:, body:, api_key: true, http_basic: false)
      conn(http_basic).send(method) do |req|
        req.url path, params
        req.headers['Api-Token'] = Sendbird.api_key if api_key
        req.headers['Content-Type'] = 'application/json, charset=utf8'
        req.body = body.to_json if body
      end
    end

    def api_key_message
      'Please set up your api key'
    end

    def http_basic_message
      'Please set up you http basic information to be able to execute this requets'
    end
  end
end
