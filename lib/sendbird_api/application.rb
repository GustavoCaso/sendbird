module SendbirdApi
  class Application
    extend Client
    ENDPOINT = 'applications'.freeze

    class << self
      def create(body)
        post(path: build_url, body: body)
      end
    end
  end
end
