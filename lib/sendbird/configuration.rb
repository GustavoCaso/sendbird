module Sendbird
  module Configuration
    PUBLIC_METHODS = [:applications, :user, :password, :default_app]

    SENDBIRD_ENDPOINT = 'https://api.sendbird.com/v3/'

    attr_accessor *PUBLIC_METHODS

    def config
      yield self
    end
  end
end
