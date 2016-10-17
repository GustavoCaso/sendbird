module Sendbird
  class User < Struct.new(:user_id, :nickname, :profile_url, :access_token, :last_seen_at, :is_online)
    def self.create_or_initialize(params)
      case params
      when Response
        new(*params.body.map{|x| x.last})
      when Hash
        response = UserApi.show(params[:user_id])
        if response.status == 200
          new(*response.body.map{|x| x.last})
        else
          new_user = UserApi.create(params)
          new(*new_user.body.map{|x| x.last})
        end
      end
    end

    private_class_method :new

    def view
      UserApi.show(user_id)
    end

    def update(body)
      UserApi.update(user_id, body)
    end

    def unread_count
      UserApi.unread_count(user_id)
    end

    def mark_as_read_all
      UserApi.mark_as_read_all(user_id)
    end

    def register_gcm_token(token)
      UserApi.register_gcm_token(user_id, token)
    end

    def register_apns_token(token)
      UserApi.register_apns_token(user_id, token)
    end

    def unregister_gcm_token(token)
      UserApi.unregister_gcm_token(user_id, token)
    end

    def unregister_apns_token(token)
      UserApi.unregister_apns_token(user_id, token)
    end

    def unregister_all_device_token
      UserApi.unregister_all_device_token(user_id)
    end
  end
end
