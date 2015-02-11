require "open-uri"
require "rexml/document"

module AOJ
  module API
    class << self

      def problem_search(problem_id)
        url = 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/problem?' + { id: problem_id }.to_query
        open(url) { |doc| REXML::Document.new doc }
      end

    end
  end
end
