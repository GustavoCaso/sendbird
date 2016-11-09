module Sendbird
  module RequestHandler
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
