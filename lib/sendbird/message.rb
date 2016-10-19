module Sendbird
  class Message
    attr_reader :user_id, :channel_url, :channel_type

    def initialize(user_id, channel_url, channel_type)
      @user_id = user_id
      @channel_url = channel_url
      @channel_type = channel_type
    end

    def send_message(type, data)
      MessageApi.send(channel_type, channel_url, message_body(type).merge(data))
      self
    end

    private
    def message_type(type)
      {
        text: 'MESG',
        file: 'FILE',
        admin: 'ADMM'
      }[type]
    end

    def message_body(type)
      case type
      when :text
        {
          "message_type": message_type(type),
          "user_id": user_id
        }
      when
        {
          "message_type": message_type(type),
          "user_id": user_id
        }
      when
        {
          "message_type": message_type(type),
        }
      end
    end
  end
end
