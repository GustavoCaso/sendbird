module Sendbird
  module RequestHandler
    def self.included(base)
      base.extend ClassMethods
    end

    def request!
        Request.new(pending_requests, api_class, default_arg).execute
      rescue InvalidRequest => e
        raise e
      ensure
        self.pending_requests = {}
      self
    end

    def merge_arguments(method, args, callback=nil)
      self.pending_requests = RequestMerger.call(pending_requests, method, args, callback)
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

    class RequestMerger
      def self.call(pending_requests, method, args, callback)
        new(pending_requests, method, args, callback).merge
      end

      attr_reader :pending_requests, :method, :args, :callback
      def initialize(pending_requests, method, args, callback)
        @pending_requests = pending_requests
        @method = method
        @args = args
        @callback = callback
      end

      def merge
        pending_requests[method] ||= {}
        case args
        when Hash
          merge_hash_arguments(args)
        else
          merge_rest_of_arguments(args)
        end
        append_callbacks(args)
        pending_requests
      end

      def merge_hash_arguments(args)
        pending_requests[method][:args] ||= {}
        pending_requests[method][:args] = pending_requests[method][:args].merge(args)
      end

      def merge_rest_of_arguments(args)
        pending_requests[method][:args] ||= []
        pending_requests[method][:args] = pending_requests[method][:args] << args if args
      end

      def append_callbacks(args)
        pending_requests[method][:callback] ||= []
        pending_requests[method][:callback] = pending_requests[method][:callback] << callback if callback
      end
    end

    class Request
      attr_reader :pending_requests, :api_class, :default_argument
      def initialize(pending_requests, api_class, default_argument)
        @pending_requests = pending_requests
        @api_class = api_class
        @default_argument = default_argument
      end

      def execute
        pending_requests.each do |method, params|
          response = case params[:args]
                     when Array
                       if params[:args].any?
                         api_class.send(method, default_argument, *params[:args])
                       else
                         api_class.send(method, default_argument)
                       end
                     when Hash
                       api_class.send(method, default_argument, params[:args])
                     end
          handle_response_status(response, method, params[:args])
          execute_callbacks(params[:callback], response)
        end
      end

      def handle_response_status(response, method, arguments)
        if response.status != 200
          raise InvalidRequest, "#{response.error_message} executing #{method} with arguments: #{arguments}"
        end
      end

      def execute_callbacks(callbacks, response)
        callbacks.each do |cb|
          cb.call(response)
        end
      end
    end
  end
end
