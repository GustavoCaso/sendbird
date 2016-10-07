module SendbirdApi
  class User
    extend Client
    class << self
      def show(user_id)
        get(path: "users/#{user_id}")
      end

      def create(body)
        post(path: 'users', body: body)
      end

      def list(params={})
        get(path: 'users', params: params)
      end

      def update(user_id, body)
        put(path: "users/#{user_id}", body: body)
      end

      def unread_count(user_id)
        get(path: "users/#{user_id}/unread_count")
      end

      def activate(user_id, body)
        put(path: "users/#{user_id}/activate", body: body)
      end

      def block(user_id, body)
        post(path: "users/#{user_id}/block", body: body)
      end

      def unblock(user_id, unblock_user_id)
        delete(path: "users/#{user_id}/block/#{unblock_user_id}")
      end

      def block_list(user_id, params={})
        get(path: "users/#{user_id}/block", params: params)
      end

      def mark_as_read_all(user_id)
        put(path: "users/#{user_id}/mark_as_read_all")
      end
    end
  end
end
