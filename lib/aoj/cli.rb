require 'thor'

module AOJ
  class CLI < Thor
    include Helper

    option :twitter, type: :boolean, aliases: :t
    option :problem, aliases: :p
    option :lang, aliases: :l
    desc "submit SOURCE_FILE", "Submit your source code"
    def submit(file)
      solution = Solution.new.tap { |s|
        s.problem  = detect_problem(file, options[:problem])
        s.language = detect_language(file, options[:lang])
        s.source   = read_file(file)
      }

      API.submit solution
      result = API.judge_result solution
      print_result result

      Twitter.post(solution, result) if options[:twitter] and Twitter.enable?
    rescue AOJ::Error::LanguageUnsupportedError,
           AOJ::Error::LanguageDetectionError,
           AOJ::Error::APIError,
           AOJ::Error::FileOpenError => e
      puts e.message
    end

    desc "omikuji", "今日の 1 問"
    def omikuji
    end

    desc "twitter", "Auth twitter account"
    def twitter
    end

    desc "languages", "List available languages"
    def languages
    end

    desc "test SOURCE_FILE", "Local test"
    def test
    end

  end
end
