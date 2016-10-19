module Sendbird
  class User
    class InvalidRequest < StandardError; end

    attr_reader :user_id, :pending_requests, :gcm_tokens, :apns_tokens
    def initialize(user_id)
      @user_id = user_id
      @gcm_tokens = []
      @apns_tokens = []
      @pending_requests = []
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

    # Accessors
    def user_information=(user_information={})
      pending_requests << {
        method: :update,
        args: [user_id, user_information]
      }
      self
    end

    def nickname=(nickname)
      pending_requests << {
        method: :update,
        args: [user_id, {nickname: nickname}]
      }
      self
    end

    def profile_url=(profile_url)
      pending_requests << {
        method: :update,
        args: [user_id, {profile_url: profile_url}]
      }
      self
    end

    def issue_access_token=(issue_access_token)
      pending_requests << {
        method: :update,
        args: [user_id, {issue_access_token: issue_access_token}]
      }
      self
    end

    def activate
      pending_requests << {
        method: :activate,
        args: [user_id, { activate: true }]
      }
      self
    end

    def deactivate
      pending_requests << {
        method: :activate,
        args: [user_id, { activate: false }]
      }
      self
    end

    def push_preferences=(push_preferences={})
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, push_preferences]
      }
      self
    end

    def timezone=(timezone)
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, { timezone: timezone }]
      }
      self
    end

    def start_hour=(start_hour)
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, { start_hour: start_hour }]
      }
      self
    end

    def end_hour=(end_hour)
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, { end_hour: end_hour }]
      }
      self
    end

    def start_min=(start_min)
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, { start_min: start_min }]
      }
      self
    end

    def end_min=(end_min)
      pending_requests << {
        method: :update_push_preferences,
        args: [user_id, { end_min: end_min }]
      }
      self
    end

    def register_gcm_token(token)
      pending_requests << {
        method: :register_gcm_token,
        args: [user_id, token],
        callback: ->(response){ self.gcm_tokens << response.body['token'] }
      }
      self
    end

    def register_apns_token(token)
      pending_requests << {
        method: :register_apns_token,
        args: [user_id, token],
        callback: ->(response){ self.apns_tokens << response.body['token'] }
      }
      self
    end

    def unregister_gcm_token(token)
      pending_requests << {
        method: :unregister_gcm_token,
        args: [user_id, token],
        callback: ->(response){ self.gcm_tokens.delete(response.body['token'])}
      }
      self
    end

    def unregister_apns_token(token)
      pending_requests << {
        method: :unregister_apns_token,
        args: [user_id, token],
        callback: ->(response){ self.apns_tokens.delete(response.body['token'])}
      }
      self
    end

    def unregister_all_device_token
      pending_requests << {
        method: :unregister_all_device_token,
        args: [user_id],
        callback: ->(response) { self.apns_tokens = []; self.gcm_tokens = []; }
      }
      self
    end

    def mark_as_read_all
      pending_requests << {
        method: :mark_as_read_all,
        args: [user_id]
      }
      self
    end

    def group_channels
      @group_channels ||= GroupChannelApi.list(user_id: user_id, show_empty: true).body['channels']
    end

    def group_channel(channel_url)
      GroupChannel.new(user_id, channel_url)
    end

    def request!
      pending_requests.each do |request|
        response = UserApi.send(request[:method], *request[:args])
        if response.status != 200
          self.pending_requests = []
          raise InvalidRequest.new(
            error_message(
              response.error_message,
              request[:method],
              request[:args]
            )
          )
        end
        if request[:callback]
          request[:callback].call(response)
        end
      end
      self.pending_requests = []
      self
    end

    private
    attr_writer :pending_requests, :apns_tokens, :gcm_tokens

    def error_message(error_message, method_name, args)
      "Invalid request for User with user_id: #{user_id}, error message: #{error_message} the request method was #{method_name} with args: #{args}"
    end
  end
end
