module SendbirdApi
  class MetaCounter
    extend Client
    ENDPOINT = 'metacounter'.freeze

    class << self
      def create(channel_type, channel_url, body)
        post(path: build_url(channel_type, channel_url, ENDPOINT), body: body)
      end

      def view(channel_type, channel_url, params={})
        get(path: build_url(channel_type, channel_url, ENDPOINT), params: params)
      end

      def view_by_key(channel_type, channel_url, key)
        get(path: build_url(channel_type, channel_url, ENDPOINT, key))
      end

      def update(channel_type, channel_url, body)
        put(path: build_url(channel_type, channel_url, ENDPOINT), body: body)
      end

      def update_by_key(channel_type, channel_url, key, body)
        put(path: build_url(channel_type, channel_url, ENDPOINT, key), body: body)
      end

      def destroy(channel_type, channel_url)
        delete(path: build_url(channel_type, channel_url, ENDPOINT))
      end

      def destroy_by_key(channel_type, channel_url, key)
        delete(path: build_url(channel_type, channel_url, ENDPOINT, key))
      end
    end

    def self.build_url(*args)
      args_dup = args.dup
      args_dup.join('/')
    end
  end
end
