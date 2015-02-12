require 'thor'

module AOJ
  class CLI < Thor
    include Helper

    option :twitter, type: :boolean, aliases: :t
    option :problem, aliases: :p
    option :lang, aliases: :l
    desc "submit SOURCE_FILE", "Submit your source code"
    def submit(file)
      language = parse_language(file, options[:lang])
      problem_id = parse_problem_id(file, options[:problem])
      validate_problem_id!(problem_id)
      solution = read_file(file)

      Submit.submit(solution, language, problem_id)
      result = Result.fetch(problem_id)
      print_result result

      Twitter.post(problem_id, result[:status], language) if options[:twitter] and Twitter.enable?
    rescue AOJ::Error::LanguageUnsupportedError,
           AOJ::Error::LanguageDetectionError,
           AOJ::Error::InvalidProblemIdError => e
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
