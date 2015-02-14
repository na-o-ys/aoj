require "open-uri"
require "rexml/document"

module AOJ
  module API
    TOLERANCE_SEC = 30 # to identify judge result of a submission
    RETRY_SEC = 30 # max retry sec fetching result

    class << self

      def problem_search(problem_id)
        base_url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem'
        params = { id: problem_id }
        uri = URI.parse("#{base_url}?#{params.to_query}")

        doc = REXML::Document.new(AOJ::HTTP.get(uri))
        if doc.elements['problem/id'].nil?
          raise AOJ::Error::APIError, "Invalid response, problem id may be invalid (#{problem_id})"
        end

        AOJ::Problem.new.tap do |p|
          v = ->(k) { doc.get_text(k).try(:value).try(:strip) }
          p.id           = v['problem/id']
          p.name         = v['problem/name']
          p.available    = v['problem/available'] == '1'
          p.time_limit   = v['problem/problemtimelimit'].to_i
          p.memory_limit = v['problem/problemmemorylimit'].to_i
        end
      end

      def status_log_search(problem, credential)
        base_url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/status_log'

        statuses = []
        start = 0, limit = 100
        loop do
          params = {
            'user_id'    => credential.username,
            'problem_id' => problem.id,
            'start'      => start,
            'limit'      => limit
          }
          uri = URI.parse("#{base_url}?#{params.to_query}")

          # TODO: non-blocking
          res = REXML::Document.new(AOJ::HTTP.get(uri))
                  .get_elements('status_list/status')
          statuses += res

          break if res.size < limit
          start += limit
        end

        statuses.map do |s|
          v = -> (k) { s.get_text(k).try(:value).try(:strip) }
          AOJ::Status.new.tap { |o|
            o.run_id          = v['run_id'].to_i,
            o.user_id         = v['user_id'],
            o.problem_id      = v['problem_id'].to_i,
            o.submission_date = Time.at(v['submission_date'].to_i/1000),
            o.status          = v['status'],
            o.language        = v['language'],
            o.cputime         = v['cputime'],
            o.memory          = v['memory'],
            o.code_size       = v['code_size']
          }
        end
      end

      def submit(solution, credential)
        uri = URI.parse('http://judge.u-aizu.ac.jp/onlinejudge/servlet/Submit')
        params = {
          'userID'     => credential.username,
          'password'   => credential.password,
          'problemNO'  => solution.problem.id,
          'sourceCode' => solution.source,
          'language'   => solution.language.submit_name
        }

        if AOJ::HTTP.post_form(uri, params).code != '200'
          raise AOJ::Error::APIError, 'Failed to submit'
        end
        solution
      end

      def judge_result(solution, submission_date, credential)
        start_time = Time.now
        wait_time = 5

        loop do
          if Time.now - start_time > RETRY_SEC
            raise AOJ::Error::FetchResultError, 'Failed to fetch result'
          end

          sleep wait_time

          hit = status_log_search(solution.problem, credential)
            .select { |s|
              (s.submission_date - submission_date).abs < TOLERANCE_SEC
            }
            .max_by(&:submission_date)

          return hit if hit
        end
      end
    end
  end
end
