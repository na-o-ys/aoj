require "open-uri"
require "rexml/document"

module AOJ
  module API
    class << self

      def problem_search(problem_id)
        url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem?' + { id: problem_id }.to_query
        doc = REXML::Document.new(open(url))
        if doc.elements['problem/id'].nil?
          raise AOJ::Error::APIError, "Invalid response, problem id may be invalid (#{problem_id})"
        end
        AOJ::Problem.new.tap do |p|
          p.id           = doc.elements['problem/id'].text.strip
          p.name         = doc.elements['problem/name'].text.strip
          p.available    = doc.elements['problem/available'].text.strip == '1'
          p.time_limit   = doc.elements['problem/problemtimelimit'].text.to_i
          p.memory_limit = doc.elements['problem/problemmemorylimit'].text.to_i
        end
      end

      def submit(solution)
        puts solution.problem.id
        puts solution.problem.name
      end

    end
  end
end
