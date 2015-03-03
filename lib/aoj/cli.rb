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

      if options[:twitter] and result.status == 'Accepted'
        unless conf.has_twitter_credential?
          puts
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
      unless conf.has_credential?
        input_credentials
        puts
      end

      problem = AOJ::Problem.random_icpc(conf['username'])
      title = "ID #{problem.id}"
      width = title.size
      line = "-" * (width + 4)
      title_line = "| #{title} |"
      lspace = " " * ((width + 1)/2)
      rspace = " " * (width + 1 - (width + 1)/2)
      body = [problem.name.split("")]
        .transpose
        .map { |s| "|#{lspace}#{s[0]}#{rspace}|" }

      outer_width = problem.url.size
      outer_lspace = " " * (outer_width/2 - line.size/2 - 2)
      puts [line, title_line, line, body, line]
        .flatten
        .map { |s| outer_lspace + s }
        .join("\n")
      puts
      puts problem.url
      puts
    rescue AOJ::Error::NoProblemLeftError
      puts "No problem left. You are crazy!"
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
