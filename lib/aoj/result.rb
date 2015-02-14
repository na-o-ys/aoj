module AOJ
  class Result
    attr_accessor :run_id, :user_id, :problem_id, :submission_date, :status, :language, :cputime, :memory, :code_size

    RETRY_COUNT = 9

    def self.uri(username)
      @uri ||= "http://" + Constant[:uri] + Constant[:result_path] + "?user_id=" + username
    end

    # TODO: use API
    def self.fetch(problem)
      username = AOJ::Configuration.login_credentials[:username]
      time_begin = Time.now - 60
      wait_time = 2

      result = nil
      RETRY_COUNT.times {
        sleep(wait_time)
        xml = HTTP.open(uri(username)).read
        begin
          result = parse(xml, username, problem, time_begin) 
        rescue 
          puts $!.message
          wait_time += 1
        else
          break
        end
      }

      result
    end

    def self.parse(text, username, problem, time_begin)
      str = text.gsub(/\s/, " ")
      submission_regexp = /<status>(.*?<status>.*?<\/status>.*?)<\/status>/
      str.scan(submission_regexp){ |matches|
        match = matches[0]

        result = {}
        result[:run_id   ] = extract(match, "run_id").to_i
        result[:problem  ] = extract(match, "problem_id")
        result[:time     ] = Time.at(extract(match, "submission_date").to_i / 1000)
        result[:status   ] = extract(match, "status")
        result[:language ] = extract(match, "language")
        result[:cputime  ] = extract(match, "cputime").to_i
        result[:memory   ] = extract(match, "memory").to_i
        result[:code_size] = extract(match, "code_size").to_i
        if (problem == result[:problem] && result[:time] > time_begin)
          return result
        end
      }

      raise "in judge queue..."
    end

    def self.extract(text, target)
      return text.scan(/<#{target}>(.*?)<\/#{target}>/)[0][0].strip
    end
  end
end
