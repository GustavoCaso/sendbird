require 'faraday'

module Sendbird
  module Client
    class ApiKeyMissingError < StandardError; end
    class HttpBasicMissing < StandardError; end
    class NotValidApplication < StandardError; end

    PUBLIC_METHODS = [:get, :post, :put, :delete]

    PUBLIC_METHODS.each do |method|
      define_method(method) do |path: , params: nil , body: nil, app: nil|
        fail ApiKeyMissingError.new(api_key_message) unless api_key(app)
        response = api_token_request(method: method, path: path, params: params, body: body)
        Response.new(response.status, response.body)
      end
    end

    PUBLIC_METHODS.each do |method|
      define_method("#{method}_http_basic") do |path: , params: nil , body: nil, app: nil|
        fail HttpBasicMissing.new(http_basic_message) if sendbird_user.nil? || sendbird_password.nil?
        response = http_basic_request(method: method, path: path, params: params, body: body)
        Response.new(response.status, response.body)
      end
    end

    def api_key(app)
      if app
        if api_key = Sendbird.applications[app]
          @api_key = api_key
        else
          fail NotValidApplication.new(invalid_application_message(app))
        end
      else
        @api_key = Sendbird.applications[Sendbird.default_app]
      end
      @api_key
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
    def conn
      @conn ||= Faraday.new(url: Sendbird::Configuration::SENDBIRD_ENDPOINT) do |c|
                  c.request  :url_encoded
                  c.adapter  Faraday.default_adapter
                end
    end

    def http_basic_conn
      @http_basic_conn ||= Faraday.new(url: Sendbird::Configuration::SENDBIRD_ENDPOINT) do |c|
                  c.request  :url_encoded
                  c.adapter  Faraday.default_adapter
                  c.basic_auth(sendbird_user, sendbird_password)
                end
    end

    def sendbird_user
      Sendbird.user
    end

    def sendbird_password
      Sendbird.password
    end

    def api_token_request(method:, path:, params:, body:)
      conn.send(method) do |req|
        req.url path, params
        req.headers['Api-Token'] = @api_key
        req.headers['Content-Type'] = 'application/json, charset=utf8'
        req.body = body.to_json if body
      end
    end

    def http_basic_request(method:, path:, params:, body:)
      http_basic_conn.send(method) do |req|
        req.url path, params
        req.headers['Content-Type'] = 'application/json, charset=utf8'
        req.body = body.to_json if body
      end
    end

    def api_key_message
      'Plase set up your applications and default_app'
    end

    def http_basic_message
      'Please set up you http basic information to be able to execute this requets'
    end

    def invalid_application_message(app)
      "Application name (#{app}) not found in the configuration, please check your configuration"
    end
  end
end
