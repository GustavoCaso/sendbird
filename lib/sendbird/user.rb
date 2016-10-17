module Sendbird
  class User < Struct.new(:user_id, :nickname, :profile_url, :access_token, :last_seen_at, :is_online)
    class InvalidParams < StandardError; end
    class UserError < StandardError; end

    def self.find_or_create(params)
      case params
      when Sendbird::Response
        new(params)
      when Hash
        user_id = params[:user_id] || params['user_id']
        response = UserApi.show(user_id)
        response.status == 200 ? new(response) : new(UserApi.create(params))
      else
        raise InvalidParams, 'Please provide an Senbird::Response object or a hash with user_id key'
      end
    end

    private_class_method :new

    def initialize(response)
      if response.status == 200
        super(*response.body.values)
      else
        raise UserError, "Error encounter #{response.error_message}"
      end
    end

    def update(body)
      self.class.find_or_create(UserApi.update(user_id, body))
    end

    def update_nickname(nickname)
      self.class.find_or_create(UserApi.update(user_id, {nickname: nickname}))
    end

    def update_profile_url(profile_url)
      self.class.find_or_create(UserApi.update(user_id, {profile_url: profile_url}))
    end

    def update_issue_access_token(issue_access_token)
      self.class.find_or_create(UserApi.update(user_id, {issue_access_token: issue_access_token}))
    end

    def activate
      UserApi.activate(user_id, { activate: true })
    end

    def deactivate
      UserApi.activate(user_id, { activate: false })
    end

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
