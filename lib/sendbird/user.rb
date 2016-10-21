module Sendbird
  class User
    include RequestHandler

    api_class UserApi
    default_arg :user_id

    attr_reader :user_id, :pending_requests, :gcm_tokens, :apns_tokens
    def initialize(user_id)
      @user_id = user_id
      @gcm_tokens = []
      @apns_tokens = []
      @pending_requests = {}
      yield(self) if block_given?
    end

    def in_sync?
      pending_requests.empty?
    end

    #Getters
    def get_user
      response = UserApi.view(user_id)
      if response.status == 200
        response.body
      else
        raise InvalidRequest.new(
          error_message(
            response.error_message,
            __method__,
            user_id
          )
        )
      end
    end

    def get_unread_count
      response = UserApi.unread_count(user_id)
      if response.status == 200
        response.body['unread_count']
      else
        raise InvalidRequest.new(
          error_message(
            response.error_message,
            __method__,
            user_id
          )
        )
      end
    end

    def get_push_preferences
      response = UserApi.push_preferences(user_id)
      if response.status == 200
        response.body
      else
        raise InvalidRequest.new(
          error_message(
            response.error_message,
            __method__,
            user_id
          )
        )
      end
    end

    # Setters
    def user_information=(user_information={})
      merge_arguments(:update, user_information)
      self
    end
    alias_method :user_information, :user_information=

    def nickname=(nickname)
      merge_arguments(:update, {nickname: nickname})
      self
    end
    alias_method :nickname, :nickname=

    def profile_url=(profile_url)
      merge_arguments(:update, {profile_url: profile_url})
      self
    end
    alias_method :profile_url, :profile_url=

    def issue_access_token=(issue_access_token)
      merge_arguments(:update, {issue_access_token: issue_access_token})
      self
    end
    alias_method :issue_access_token, :issue_access_token=

    def activate
      merge_arguments(:activate, { activate: true })
      self
    end

    def deactivate
      merge_arguments(:activate, { activate: false })
      self
    end

    def push_preferences=(push_preferences={})
      merge_arguments(:update_push_preferences, push_preferences)
      self
    end
    alias_method :push_preferences, :push_preferences=

    def timezone=(timezone)
      merge_arguments(:update_push_preferences, { timezone: timezone })
      self
    end
    alias_method :timezone, :timezone=

    def start_hour=(start_hour)
      merge_arguments(:update_push_preferences, { start_hour: start_hour })
      self
    end
    alias_method :start_hour, :start_hour=

    def end_hour=(end_hour)
      merge_arguments(:update_push_preferences, { end_hour: end_hour })
      self
    end
    alias_method :end_hour, :end_hour=

    def start_min=(start_min)
      merge_arguments(:update_push_preferences, { start_min: start_min })
      self
    end
    alias_method :start_min, :start_min=

    def end_min=(end_min)
      merge_arguments(:update_push_preferences, { end_min: end_min })
      self
    end
    alias_method :end_min, :end_min=

    def register_gcm_token(token)
      merge_arguments(:register_gcm_token, token, ->(response){ self.gcm_tokens << response.body['token'] })
      self
    end

    def register_apns_token(token)
      merge_arguments(:register_apns_token, token, ->(response){ self.apns_tokens << response.body['token'] })
      self
    end

    def unregister_gcm_token(token)
      merge_arguments(:unregister_gcm_token, token, ->(response){ self.gcm_tokens.delete(response.body['token'])})
      self
    end

    def unregister_apns_token(token)
      merge_arguments(:unregister_apns_token, token, ->(response){ self.apns_tokens.delete(response.body['token'])})
      self
    end

    def unregister_all_device_token
      merge_arguments(:unregister_all_device_token, nil, ->(response) { self.apns_tokens = []; self.gcm_tokens = []; })
      self
    end

    def mark_as_read_all
      merge_arguments(:mark_as_read_all, {})
      self
    end

    def group_channel(channel_url)
      GroupChannel.new(user_id, channel_url)
    end

    private
    attr_writer :pending_requests, :apns_tokens, :gcm_tokens
    def error_message(error_message, method_name, args)
      "Invalid request for User with user_id: #{user_id}, error message: #{error_message} the request method was #{method_name} with args: #{args}"
    end
  end
end
