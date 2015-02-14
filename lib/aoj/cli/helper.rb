require "io/console"

module AOJ
  module CLI::Helper
    def detect_language(file, opt)
      language =
        if opt
          AOJ::Language.find(opt.to_sym)
        else
          AOJ::Language.find_by_ext(File.extname(file))
        end

      unless language
        raise AOJ::Error::LanguageDetectionError, "Failed to detect language, check `aoj langs`"
      end
      language
    end

    def detect_problem(file, opt)
      problem_id = opt || File.basename(file, ".*")
      API.problem_search problem_id
    end

    def read_file(file)
      File.read(file)
    rescue Errno::ENOENT => e
      raise AOJ::Error::FileOpenError, e.message
    end

    def print_solution_info(solution)
      puts "Language: #{solution.language.submit_name}"
      puts "Problem:"
      puts "  id:   #{solution.problem.id}"
      puts "  name: #{solution.problem.name}"
    end

    def print_result(result)
      puts "Judge result:"
      puts "  Status:    #{result.status}"     if result.status
      puts "  Code Size: #{result.code_size}"  if result.code_size
      puts "  CPU Time:  #{result.cputime}"    if result.cputime
      puts "  Memory:    #{result.memory}"     if result.memory
      puts "  URL:       #{result.review_url}" if result.review_url
    end

    def input_credentials
      credential = Credential.new

      loop do
        puts "Input AOJ username:"
        credential.username = STDIN.gets.strip
        puts "Input AOJ password:"
        credential.password = STDIN.noecho(&:gets).strip
        puts
        break if credential.valid?
        puts "Invalid username/password."
      end

      conf['username'] = credential.username
      conf['password'] = credential.password
      conf.save
      puts "Your credential is saved at #{conf.rcfile_path}"
    end

    def twitter_auth
      request_token = Twitter.instance.request_token
      puts "Connect to twitter account. Please access to url."
      puts request_token.authorize_url
      puts "Input PIN:"
      pin = STDIN.gets.strip
      puts
      access_token = request_token.get_access_token(oauth_verifier: pin)
      conf['twitter'] = {
        'access_token'        => access_token.token,
        'access_token_secret' => access_token.secret
      }
      conf.save
      puts "Your credential is saved at #{conf.rcfile_path}"
    end

    def conf
      Conf.instance
    end
  end
end
