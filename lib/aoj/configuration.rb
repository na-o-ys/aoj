require "json"

module AOJ
  module Configuration

    class << self
      def config
        @config ||= JSON.parse(open(ENV["HOME"] + "/.aoj").read) 
      end

      def login_credentials
        { 
          username: config["username"],
          password: config["password"]
        }
      end

      def tw_consumer_key
        config["tw_consumer_key"]
      end

      def tw_consumer_secret
        config["tw_consumer_secret"]
      end

      def tw_access_token
        config["tw_access_token"]
      end

      def tw_access_token_secret
        config["tw_access_token_secret"]
      end

    end

  end
end
