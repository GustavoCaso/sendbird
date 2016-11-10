module Sendbird
  class OpenChannelApi
    extend Client
    ENDPOINT = 'open_channels'.freeze

    class << self
      def view(channel_url, params={})
        get(path: build_url(channel_url), params: params)
      end

      def create(body={})
        post(path: build_url, body: body)
      end

      def list(params={})
        get(path: build_url, params: params)
      end

      def destroy(channel_url)
        delete(path: build_url(channel_url))
      end

      def update(channel_url, body)
        put(path: build_url(channel_url), body: body)
      end

      def participants(channel_url, params)
        get(path: build_url(channel_url, 'participants'), params: params)
      end

      def freeze(channel_url, body)
        put(path: build_url(channel_url, 'freeze'), body: body)
      end

      def ban_user(channel_url, body)
        post(path: build_url(channel_url, 'ban'), body: body)
      end

      def ban_list(channel_url, params={})
        get(path: build_url(channel_url, 'ban'), params: params)
      end

      def ban_update(channel_url, user_id, body)
        put(path: build_url(channel_url, 'ban', user_id), body: body)
      end

      def ban_delete(channel_url, user_id)
        delete(path: build_url(channel_url, 'ban', user_id))
      end

      def ban_view(channel_url, user_id)
        get(path: build_url(channel_url, 'ban', user_id))
      end

      def mute(channel_url, body)
        post(path: build_url(channel_url, 'mute'), body: body)
      end

      def mute_list(channel_url, params={})
        get(path: build_url(channel_url, 'mute'), params: params)
      end

      def mute_delete(channel_url, user_id)
        delete(path: build_url(channel_url, 'mute', user_id))
      end

      def mute_view(channel_url, user_id)
        get(path: build_url(channel_url, 'mute', user_id))
      end
    end
  end
end
