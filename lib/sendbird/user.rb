module Sendbird
  class User
    class InvalidRequest < StandardError; end

    attr_reader :user_id, :pending_requests
    def initialize(user_id)
      @user_id = user_id
      @pending_requests = []
    end

    def in_sync?
      pending_requests.empty?
    end

    def nickname=(nickname)
      pending_requests << {method: :update, args: [user_id, {nickname: nickname}]}
      self
    end

    def profile_url=(profile_url)
      pending_requests << {method: :update, args: [user_id, {profile_url: profile_url}]}
      self
    end

    def issue_access_token=(issue_access_token)
      pending_requests << {method: :update, args: [user_id, {issue_access_token: issue_access_token}]}
      self
    end

    def activate
      pending_requests << {method: :activate, args: [user_id, { activate: true }]}
      self
    end

    def deactivate
      pending_requests << {method: :activate, args: [user_id, { activate: false }]}
      self
    end

    def update!
      pending_requests.each do |request|
        response = UserApi.send(request[:method], *request[:args])
        if response.status != 200
          self.pending_requests = []
          raise InvalidRequest, "Invalid request for User with user_id: #{user_id}, error message: #{response.error_message}, the pending requets will be clear"
        end
      end
      self.pending_requests = []
      self
    end

    private
    attr_writer :pending_requests

    def push_preferences
      UserApi.push_preferences(user_id).body
    end

    def update_push_preferences(body)
      UserApi.update_push_preferences(user_id, body)
    end

    def delete_push_preferences
      UserApi.delete_push_preferences(user_id)
    end

    def update_timezone(timezone)
      UserApi.update_push_preferences(user_id, { timezone: timezone }).body
    end

    def update_start_hour(start_hour)
      UserApi.update_push_preferences(user_id, { start_hour: start_hour }).body
    end

    def update_end_hour(end_hour)
      UserApi.update_push_preferences(user_id, { end_hour: end_hour }).body
    end

    def update_start_min(start_min)
      UserApi.update_push_preferences(user_id, { start_min: start_min }).body
    end

    def update_end_min(end_min)
      UserApi.update_push_preferences(user_id, { end_min: end_min }).body
    end

    def unread_count
      UserApi.unread_count(user_id).body['unread_count']
    end

    def mark_as_read_all
      UserApi.mark_as_read_all(user_id)
    end

    def register_gcm_token(token)
      UserApi.register_gcm_token(user_id, token).body
    end

    def register_apns_token(token)
      UserApi.register_apns_token(user_id, token).body
    end

    def unregister_gcm_token(token)
      UserApi.unregister_gcm_token(user_id, token).body
    end

    def unregister_apns_token(token)
      UserApi.unregister_apns_token(user_id, token).body
    end

    def unregister_all_device_token
      UserApi.unregister_all_device_token(user_id).body
    end
  end
end
