module Sendbird
  class GroupChannel
    class MissingUserId < StandardError; end
    include RequestHandler

    api_class GroupChannelApi
    default_arg :channel_url

    attr_reader :channel_url, :user_id, :pending_requests
    def initialize(channel_url, user_id = :missing_user_id)
      @channel_url = channel_url
      @user_id = user_id
      @pending_requests = {}
      yield(self) if block_given?
    end

    def name=(name)
      merge_arguments(:update, {name: name})
      self
    end

    def cover_url=(cover_url)
      merge_arguments(:update, {cover_url: cover_url})
      self
    end

    def data=(data)
      merge_arguments(:update, {data: data})
      self
    end

    def is_distinct=(is_distinct)
      merge_arguments(:update, {is_distinct: is_distinct})
      self
    end

    def send_message(type, data)
      message.send(type, data)
    end

    def message
      return @message if defined?(@message)
      if user_id == :missing_user_id
        raise MissingUserId, 'Please provide an user_id at initialize to been able to use send_message'
      end
      @message ||= Message.new(user_id, channel_url, 'group_channels')
    end

    private
    attr_writer :pending_requests
  end
end
