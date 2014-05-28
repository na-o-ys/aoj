require "twitter"

module AOJ
  module Tweet
    def self.enable?
      client.credentials?
    end

    def self.post(problem, status, language, answer_uri = nil)
      client.update posttext(problem, status, language, answer_uri)
    end

    def self.posttext(problem, status, language, answer_uri)
      problem_uri = Util.problem_uri(problem)
      title = Util.problem_title(problem)

      texts = []
      texts << "%s #AOJ"
      texts << "[%s:%s] %s"
      texts << "MY ANSWER: %s" if answer_uri
      texts << "LANG: %s"
      text = texts.join("\n")

      wordcount = problem.length + text.length - 2*4 + 20 + 
        status.length + language.length
      wordcount += 20 if answer_uri

      if wordcount + title.length > 140
        title = title[0, 140 - wordcount - 1 - 2] + ".."
      end

      text % if answer_uri
        [status, problem, title, problem_uri, answer_uri, language]
      else
        [status, problem, title, problem_uri, language]
      end
    end

    def self.client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = Configuration.tw_consumer_key
        config.consumer_secret     = Configuration.tw_consumer_secret
        config.access_token        = Configuration.tw_access_token
        config.access_token_secret = Configuration.tw_access_token_secret
      end
    end
  end
end
