module AOJ
  module CLI::Helper
    def parse_language(file, opt)
      if opt
        opt.to_sym.tap do |lang|
          unless Language.languages.include?(lang)
            raise Error::LanguageUnsupportedError, "Unsupported language (#{lang})"
          end
        end
      else
        Util.extract_language file
      end
    end

    def parse_problem_id(file, opt)
      opt || Util.extract_problem(file)
    end

    def validate_problem(problem_id)
      AOJ::API.problem_search(problem_id)
    end

    def read_file(file)
      File.read(file)
      # TODO: errorshori
    end
  end
end
