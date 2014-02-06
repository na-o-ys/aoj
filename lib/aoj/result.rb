require "open-uri"

module AOJ
  module Result

    RETRY_COUNT = 9

    def self.uri
      @uri ||= "http://" + Constant[:uri] + Constant[:result_path]
    end

    def self.fetch(username, time_begin)

      proxy_former, proxy_latter = (ENV["http_proxy"] || '').sub(/http:\/\//, '').split('@')
        if proxy_latter == nil then
          proxy_url = "http://" + proxy_former
        else
          proxy_user, proxy_pass = proxy_former.split(':')
          proxy_url = "http://" + proxy_latter
        end

      wait_time = 2

      result = nil
      RETRY_COUNT.times {
        sleep(wait_time)
        xml = open(uri, { :proxy_http_basic_authentication => [proxy_url, proxy_user, proxy_pass] }).read
        begin
          result = parse(xml, username, time_begin) 
        rescue 
          puts $!.message
          wait_time += 1
        else
          break
        end
      }

      result
    end

    def self.parse(text, username, time_begin)
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
          if result[:time] > time_begin
            return result
          end
        end
      }
      raise "in judge queue..."
    end

    def self.extract(text, target)
      return text.scan(/<#{target}>(.*?)<\/#{target}>/)[0][0].strip
    end
  end
end
