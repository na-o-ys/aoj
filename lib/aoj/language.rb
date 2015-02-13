module AOJ
  class Language
    attr_accessor :key, :submit_name

    langs = { # TODO: yml config
      c:          "C",
      cpp:        "C++",
      java:       "JAVA",
      ruby:       "Ruby",
      cpp11:      "C++11",
      csharp:     "C#",
      d:          "D",
      python:     "Python",
      php:        "PHP",
      javascript: "JavaScript"
    } 

    @languages = langs.each.map { |key, submit_name|
      Language.new.tap { |l|
        l.key         = key
        l.submit_name = submit_name
      }
    }.freeze

    @extnames = { #TODO: yml config
      ".c"    => :c,
      ".cpp"  => :cpp,
      ".cc"   => :cpp,
      ".C"    => :cpp,
      ".java" => :java,
      ".rb"   => :ruby,
      ".cs"   => :csharp,
      ".d"    => :d,
      ".py"   => :python,
      ".php"  => :php,
      ".js"   => :javascript
    }.freeze

    class << self
      attr_reader :languages, :extnames

      def find(key)
        languages.find { |l| l.key == key }
      end

      def find_by_ext(ext)
        languages.find { |l| l.key == extnames[ext] }
      end

    end
  end
end
