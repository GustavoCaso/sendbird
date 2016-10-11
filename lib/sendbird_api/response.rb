module SendbirdApi
  class Response
    attr_reader :status, :body
    def initialize(status, body)
      @status = status
      @body = JSON[body]
    end

    def error_message
      if body['error']
        body['message']
      else
        'Not any error to report'
      end
    end

    def error_code
      if body['error']
        body['code']
      else
        'Not any error to report'
      end
    end
  end
end
