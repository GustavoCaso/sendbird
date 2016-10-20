module Sendbird
  module RequestHandler
    def self.included(base)
      base.extend ClassMethods
    end

    def request!
      pending_requests.each do |method, params|
        response = case params[:args]
                   when Array
                     if params[:args].any?
                       api_class.send(method, default_arg, *params[:args])
                     else
                       api_class.send(method, default_arg)
                     end
                   when Hash
                     api_class.send(method, default_arg, params[:args])
                   end
        if response.status != 200
          self.pending_requests = {}
          raise InvalidRequest.new(
            error_message(
              response.error_message,
              method,
              params[:args]
            )
          )
        end
        params[:callback].each do |cb|
          cb.call(response)
        end
      end
      self.pending_requests = {}
      self
    end

    def merge_arguments(method, args, callback=nil)
      pending_requests[method] ||= {}
      case args
      when Hash
        pending_requests[method][:args] ||= {}
        pending_requests[method][:args] = pending_requests[method][:args].merge(args)
      else
        pending_requests[method][:args] ||= []
        pending_requests[method][:args] = pending_requests[method][:args] << args if args
      end
      pending_requests[method][:callback] ||= []
      pending_requests[method][:callback] = pending_requests[method][:callback] << callback if callback
    end

    def default_arg
      self.send(self.class.instance_variable_get(:@default_arg))
    end

    def api_class
      self.class.instance_variable_get(:@api_class)
    end

    module ClassMethods
      def api_class(api_class)
        @api_class = api_class
      end

      def default_arg(method)
        @default_arg = method
      end
    end
  end
end
