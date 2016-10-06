module SendbirdApi
  class User
    extend Client
    class << self
      def create(params)
        post(path: 'users', body: params)
      end
    end
  end
end
