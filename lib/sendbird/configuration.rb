require 'dry-configurable'

module Sendbird
  class Configuration
    class MissingConfigurationError < StandardError
      def initialize(keys)
        super("missing #{keys}. Please configure all setttings using Sendbird.configure")
      end
    end

    include Dry::Configurable

    setting :api_token
    setting :app_id
    setting :username
    setting :password

    def validate!
      missing_keys = []
      config.values.each do |key, value|
        missing_keys << key unless value
      end
      raise MissingConfigurationError.new(missing_keys) if missing_keys.any?
    end
  end
end
