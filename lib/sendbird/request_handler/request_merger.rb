module Sendbird
  module RequestHandler
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
  end
end
