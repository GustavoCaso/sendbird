module SendbirdApi
  class Response
    attr_reader :status, :response_body
    def initialize(status, response_body)
      @status = status
      @response_body = JSON[response_body]
    end
  end
end
