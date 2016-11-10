module Sendbird
  class ApplicationApi
    extend Client
    ENDPOINT = 'applications'.freeze

    class << self
      def create(body)
        post_http_basic(path: build_url, body: body)
      end

      def list(params={})
        get_http_basic(path: build_url, params: params)
      end

      # Right this endpoint is failing in there site
      # def view
      #   get(path: build_url)
      # end

      def delete_all
        delete_http_basic(path: build_url)
      end

      def delete
        delete_http_basic(path: build_url)
      end
    end
  end
end
