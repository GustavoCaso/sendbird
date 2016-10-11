module SendbirdApi
  class User
    extend Client
    ENDPOINT = 'users'.freeze

    class << self
      def show(user_id)
        get(path: build_url(user_id))
      end

      def create(body)
        post(path: build_url, body: body)
      end

      def list(params={})
        get(path: build_url, params: params)
      end

      def update(user_id, body)
        put(path: build_url(user_id), body: body)
      end

      def unread_count(user_id)
        get(path: build_url(user_id, 'unread_count'))
      end

      def activate(user_id, body)
        put(path: build_url(user_id, 'activate'), body: body)
      end

      def block(user_id, body)
        post(path: build_url(user_id, 'block'), body: body)
      end

      def unblock(user_id, unblock_user_id)
        delete(path: build_url(user_id, 'block', unblock_user_id))
      end

      def block_list(user_id, params={})
        get(path: build_url(user_id, 'block'), params: params)
      end

      def mark_as_read_all(user_id)
        put(path: build_url(user_id, 'mark_as_read_all'))
      end

      def register_gcm_token(user_id, token)
        register_token(user_id, 'gcm', {gcm_reg_token: token})
      end

      def register_apns_token(user_id, token)
        register_token(user_id, 'apns', {apns_device_token: token})
      end

      def unregister_gcm_token(user_id, token)
        unregister_token(user_id, 'gcm', token)
      end

      def unregister_apns_token(user_id, token)
        unregister_token(user_id, 'apns', token)
      end

      def unregister_all_device_token(user_id)
        delete(path: build_url(user_id, 'push'))
      end

      def push_preferences(user_id)
        get(path: build_url(user_id, 'push_preference'))
      end

      def update_push_preferences(user_id, body)
        put(path: build_url(user_id, 'push_preference'), body: body)
      end

      def delete_push_preferences(user_id)
        delete(path: build_url(user_id, 'push_preference'))
      end
    end

    def self.register_token(user_id,token_type, body)
      post(path: build_url(user_id, 'push', token_type), body: body)
    end

    def self.unregister_token(user_id, token_type, token)
      delete(path: build_url(user_id, 'push', token_type, token))
    end

    private_class_method :register_token, :unregister_token
  end
end
