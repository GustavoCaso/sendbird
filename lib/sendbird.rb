require "sendbird/client"
require "sendbird/configuration"
require "sendbird/invalid_request"
require "sendbird/response"
require "sendbird/application_api"
require "sendbird/user_api"
require "sendbird/open_channel_api"
require "sendbird/group_channel_api"
require "sendbird/message_api"
require "sendbird/meta_base"
require "sendbird/meta_data_api"
require "sendbird/meta_counter_api"
require "sendbird/version"

module Sendbird
  class NotConfiguredError < StandardError; end

  class << self
    def configure
      @config = Configuration.new
      yield @config.config
      @config.validate!
      @config.finalize!
    end

    def config
      raise NotConfiguredError unless @config.frozen?
      @config.config
    end
  end
end
