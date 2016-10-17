module Sendbird
  class GroupChannel
    extend Client
    ENDPOINT = 'group_channels'.freeze

    class << self
      def create(body)
        post(path: build_url, body: body)
      end

      def list(params={})
        get(path: build_url, params: params)
      end

      def update(channel_url, body)
        put(path: build_url(channel_url), body: body)
      end

      def destroy(channel_url)
        delete(path: build_url(channel_url))
      end

      def view(channel_url, params={})
        get(path: build_url(channel_url), params: params)
      end

      def members(channel_url, params={})
        get(path: build_url(channel_url, 'members'), params: params)
      end

      def is_member?(channel_url, user_id)
        get(path: build_url(channel_url, 'members', user_id))
      end

      def invite(channel_url, body)
        post(path: build_url(channel_url, 'invite'), body: body)
      end

      def hide(channel_url, body)
        put(path: build_url(channel_url, 'hide'), body: body)
      end

      def leave(channel_url, body)
        put(path: build_url(channel_url, 'leave'), body: body)
      end
    end
  end
end
