require "open-uri"

module AOJ
  module Result

    RETRY_COUNT = 5

    def self.uri
      @uri ||= "http://" + AOJ::Configuration::AOJ_SETTING[:uri] + 
        AOJ::Configuration::AOJ_SETTING[:path_result]
    end

    def self.fetch(username)
      wait_time = 2

      result = nil
      RETRY_COUNT.times {
        sleep(wait_time)
        xml = open(uri).read
        begin
          result = parse(xml, username) 
        rescue 
          wait_time += 1
        else
          break
        end
      }

      result
    end

    def self.parse(text, username)
      str = text.gsub(/\s/, " ")
      submission_regexp = /<status>(.*?<status>.*?<\/status>.*?)<\/status>/
      str.scan(submission_regexp){ |matches|
        match = matches[0]

        result = {}
        if (username == extract(match, "user_id")) 
          result[:run_id   ] = extract(match, "run_id").to_i
          result[:problem  ] = extract(match, "problem_id")
          result[:time     ] = Time.at(extract(match, "submission_date").to_i / 1000)
          result[:status   ] = extract(match, "status")
          result[:language ] = extract(match, "language")
          result[:cputime  ] = extract(match, "cputime").to_i
          result[:memory   ] = extract(match, "memory").to_i
          result[:code_size] = extract(match, "code_size").to_i
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
