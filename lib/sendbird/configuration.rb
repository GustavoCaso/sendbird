module Sendbird
  module Configuration
    PUBLIC_METHODS = [:api_key, :user, :password]

    attr_accessor *PUBLIC_METHODS

    def config
      yield self
    end
  end
end
