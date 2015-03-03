require "rexml/document"

module AOJ
  module API
    SUBMISSION_DATE_GAP_SEC = 30 # to identify judge result of a submission
    RETRY_SEC = 30 # max retry sec fetching result
    FETCH_STATUS_WAIT_SEC = 5

    class << self

      def problem_search(problem_id)
        base_url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem'
        params = { id: problem_id }
        response = AOJ::HTTP.get(
          URI.parse("#{base_url}?#{params.to_query}")
        )
        doc = REXML::Document.new(response)

        if doc.elements['problem/id'].nil?
          raise AOJ::Error::APIError, "Problem id may be invalid (#{problem_id})"
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
          # TODO: non-blocking
          uri = URI.parse("#{base_url}?#{params.to_query}")
          res =
            REXML::Document.new(AOJ::HTTP.get(uri))
              .get_elements('status_list/status')
          statuses += res

          break if res.size < limit
          start += limit
        end

        statuses.map do |s|
          v = -> (k) { s.get_text(k).try(:value).try(:strip) }
          AOJ::Status.new.tap { |o|
            o.run_id          = v['run_id'].to_i
            o.user_id         = v['user_id']
            o.problem_id      = v['problem_id'].to_i
            o.submission_date = Time.at(v['submission_date'].to_i/1000)
            o.status          = v['status']
            o.language        = v['language']
            o.cputime         = v['cputime']
            o.memory          = v['memory']
            o.code_size       = v['code_size']
          }
        end
      end

      def user(user_id)
        url = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/user"
        params = { "id" => user_id }
        uri = URI.parse("#{url}?#{params.to_query}")
        doc = REXML::Document.new(AOJ::HTTP.get(uri))
        solved_problems = doc.get_elements('user/solved_list/problem')
        {
          id:   doc.get_text('user/id').value.strip,
          name: doc.get_text('user/name').value.strip,
          solved_list: solved_problems.map { |item|
            {
              id: item.get_text('id').value.strip
            }
          }
        }
      end

      def problem_list(volume)
        url = "http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem_list"
        params = { "volume" => volume }
        uri = URI.parse("#{url}?#{params.to_query}")
        doc = REXML::Document.new(AOJ::HTTP.get(uri))
        problems = doc.get_elements('problem_list/problem')
        problems.map do |problem|
          {
            id:   problem.get_text('id').value.strip,
            name: problem.get_text('name').value.strip
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
        loop do
          if Time.now - start_time > RETRY_SEC
            raise AOJ::Error::FetchResultError, 'Failed to fetch result'
          end

          sleep FETCH_STATUS_WAIT_SEC

          hit = status_log_search(solution.problem, credential)
            .select { |s|
              (s.submission_date - submission_date).abs < SUBMISSION_DATE_GAP_SEC
            }
            .max_by(&:submission_date)

          return hit if hit
        end
      end

      def loginable?(credential)
        uri = URI.parse("http://judge.u-aizu.ac.jp/onlinejudge/index.jsp")
        params = {
          'loginUserID'   => credential.username,
          'loginPassword' => credential.password
        }
        res = AOJ::HTTP.post_form(uri, params)
        !res.body.include?('Wrong User ID.') and !res.body.include?('Wrong Password.')
      end
    end
  end
end
