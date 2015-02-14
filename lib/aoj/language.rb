module AOJ
  class Language
    attr_accessor :key, :submit_name

    langs = { # TODO: yml config
      c:       "C",
      cpp:     "C++",
      java:    "JAVA",
      cpp11:   "C++11",
      csharp:  "C#",
      d:       "D",
      ruby:    "Ruby",
      python:  "Python",
      python3: "Python3",
      php:     "PHP",
      js:      "JavaScript"
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
    }
    if custom_ext = AOJ::Conf.instance['extname']
      custom_ext.transform_values!(&:to_sym)
      @extnames.merge! custom_ext
    end
    @extnames.freeze

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
