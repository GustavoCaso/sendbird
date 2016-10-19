module Sendbird
  class GroupChannel
    class InvalidRequest < StandardError; end

    attr_reader :user_id, :channel_url
    def initialize(user_id, channel_url)
      @user_id = user_id
      @channel_url = channel_url
      @pending_requests = []
    end

    def name=(name)
      pending_requests << {
        method: :update,
        args: [user_id, {name: name}]
      }
      self
    end

    def cover_url=(cover_url)
      pending_requests << {
        method: :update,
        args: [user_id, {cover_url: cover_url}]
      }
      self
    end

    def data=(data)
      pending_requests << {
        method: :update,
        args: [user_id, {data: data}]
      }
      self
    end

    def is_distinct=(is_distinct)
      pending_requests << {
        method: :update,
        args: [user_id, {is_distinct: is_distinct}]
      }
      self
    end

    def send_message(type, data)
      message.send_message(type, data)
    end

    def request!
      pending_requests.each do |request|
        response = GroupChannelApi.send(request[:method], *request[:args])
        if response.status != 200
          self.pending_requests = []
          raise InvalidRequest.new(
            error_message(
              response.error_message,
              request[:method],
              request[:args]
            )
          )
        end
      end
      self.pending_requests = []
      self
    end

    private
    def message
      @message ||= Message.new(user_id, channel_url, 'group_channels')
    end
  end
end
