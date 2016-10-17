module Sendbird
  class Message
    extend Client

    class << self
      def send(channel_type, channel_url, body)
        post(path: build_url(channel_type, channel_url, 'messages'), body: body)
      end

      # Get messages function can be called only
      #  from Park or Enterprise plan.
      def list(channel_type, channel_url, params)
        get(path: build_url(channel_type, channel_url, 'messages'), params: params)
      end

      def view(channel_type, channel_url, message_id)
        get(path: build_url(channel_type, channel_url, 'messages', message_id))
      end

      def destroy(channel_type, channel_url, message_id)
        delete(path: build_url(channel_type, channel_url, 'messages', message_id))
      end

      def mark_as_read(channel_type, channel_url, body)
        put(path: build_url(channel_type, channel_url, 'messages', 'mark_as_read'), body: body)
      end

      def count(channel_type, channel_url)
        get(path: build_url(channel_type, channel_url, 'messages', 'total_count'))
      end

      def unread_count(channel_type, channel_url, params)
        get(path: build_url(channel_type, channel_url, 'messages', 'unread_count'), params: params)
      end
    end

    def self.build_url(*args)
      args_dup = args.dup
      args_dup.join('/')
    end
  end
end
