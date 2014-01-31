require "open-uri"
require "nokogiri"

module AOJ
  module Util
    class << self
      def problem_uri(problem)
        "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=" + problem
      end

      def problem_title(problem)
        doc = Nokogiri::HTML(open(problem_uri(problem)))
        doc.css("#pageinfo h1.title")[0].text
      rescue
        nil
      end
    end
  end
end
