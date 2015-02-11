require "open-uri"
require "nokogiri"

module AOJ
  module Util
    class << self
      def problem_uri(problem)
        "http://" + Constant[:uri] + Constant[:problem_path] + 
          "?id=" + problem
      end

      # TODO: api利用
      def problem_title(problem)
        doc = Nokogiri::HTML(open(problem_uri(problem)))
        doc.css("#pageinfo h1.title")[0].text
      rescue
        nil
      end

      def extract_language(filename)
        AOJ::Language.map_extname_label[File.extname(filename)].tap do |label|
          raise AOJ::Error::LanguageDetectionError, "Failed to detect language (#{filename})" unless label
        end
      end

      def extract_problem(filename)
        File.basename(filename, ".*")
      end
    end
  end
end
