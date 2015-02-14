require "twitter"
require "oauth"

module AOJ
  class Twitter
    include Singleton

    CONSUMER_KEY = "0T4d46LUm3jlf5xDPeRRQIUam"
    CONSUMER_SECRET = "knA6biWCQ6oBpyVSEjHhFz3Mn8Z9UsJc7TD9h5DdZoRxBl0KBp"

    def post(solution, status)
      client.update create_text(solution, status)
    end

    def request_token
      consumer = OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        { site: "https://api.twitter.com" }
      )
      consumer.get_request_token
    end

    private
    def create_text(solution, status)
      text = <<-"EOS"
#{status.status} #AOJ
[#{solution.problem.id}:%s] %s
SOURCE: %s
LANG: #{solution.language.submit_name}
      EOS

      # Shortening problem title
      url_len = 2 * client.configuration.short_url_length
      title = solution.problem.name
      wordcount = text.length - 2 * 3 + url_len
      if wordcount > 140
        title = title[0, 140 - wordcount - 2] + ".."
      end

      text % [title, solution.problem.url, status.review_url]
    end

    def client
      @client ||= ::Twitter::REST::Client.new do |c|
        c.consumer_key        = CONSUMER_KEY
        c.consumer_secret     = CONSUMER_SECRET
        c.access_token        = conf['twitter']['access_token']
        c.access_token_secret = conf['twitter']['access_token_secret']
      end
    end

    def conf
      AOJ::Conf.instance
    end
  end
end
