require_relative "./request_handler/request"
require_relative "./request_handler/request_merger"

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
  end
end
