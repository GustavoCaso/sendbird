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

      # Right now this endpoint is failing in there site
      # def view
      #   get(path: build_url)
      # end

      def destroy_all
        delete_http_basic(path: build_url)
      end

      def destroy
        delete(path: build_url)
      end

      def profanaty(body={})
        put(path: build_url('profanity'), body: body)
      end

      def ccu
        get(path: build_url('ccu'))
      end

      def mau(params={})
        get(path: build_url('mau'), params: params)
      end

      def dau(params={})
        get(path: build_url('dau'), params: params)
      end

      def daily_message_count(params={})
        get(path: build_url('daily_count'), params: params)
      end
    end
  end
end
