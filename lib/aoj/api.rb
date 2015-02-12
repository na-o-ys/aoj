require "open-uri"
require "rexml/document"

module AOJ
  module API
    class << self

      def problem_search(problem_id)
        url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem?' + { id: problem_id }.to_query
        doc = REXML::Document.new(open(url))
        if doc.elements['problem/id'].nil?
          raise AOJ::Error::APIError, "Invalid response, argument may be invalid (#{problem_id})"
        end
        {
          id:           doc.elements['problem/id'].text.strip,
          name:         doc.elements['problem/name'].text.strip,
          available:    doc.elements['problem/available'].text.strip == '1',
          time_limit:   doc.elements['problem/problemtimelimit'].text.to_i,
          memory_limit: doc.elements['problem/problemmemorylimit'].text.to_i
        }
      end

    end
  end
end
