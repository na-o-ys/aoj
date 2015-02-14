require 'thor'

module AOJ
  class CLI < Thor
    include Helper

    option :twitter, type: :boolean, aliases: :t
    option :problem, aliases: :p
    option :lang, aliases: :l
    desc "submit SOURCE_FILE", "Submit your source code"
    def submit(file)
      unless conf.has_credential?
        input_credentials
        puts
      end

      solution = Solution.new.tap do |s|
        s.source   = read_file(file)
        s.problem  = detect_problem(file, options[:problem])
        s.language = detect_language(file, options[:lang])
      end
      print_solution_info solution
      puts

      puts "Submitting..."
      API.submit(solution, Credential.get)
      puts

      puts "Fetching judge result..."
      result = API.judge_result(solution, Time.now, Credential.get)
      puts

      print_result result

      if options[:twitter]
        unless conf.has_twitter_credential?
          twitter_auth
        end
        Twitter.instance.post(solution, result)
      end
    rescue AOJ::Error::LanguageDetectionError,
           AOJ::Error::APIError,
           AOJ::Error::FetchResultError,
           AOJ::Error::FileOpenError => e
      puts e.message
    end

    desc "omikuji", "今日の 1 問"
    def omikuji
    end

    desc "setting", "Setup login credentials"
    def setting
      input_credentials
    end

    desc "twitter", "Auth twitter account"
    def twitter
      twitter_auth
    end

    desc "langs", "List available languages"
    def langs
      puts "List available languages:"
      print "  "
      puts Language.languages.map(&:key).join(", ")

      puts
      puts "Auto-detect extensions:"
      puts "  " + "[ext]".ljust(10) + "[lang]"
      Language.extnames.each do |k, v|
        puts "  " + k.ljust(10) + v.to_s
      end
    end
  end
end
