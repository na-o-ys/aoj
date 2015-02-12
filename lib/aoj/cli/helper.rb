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

    def validate_problem_id!(problem_id)
      err = -> { raise AOJ::Error::InvalidProblemIdError, "Invalid problem id #{problem_id}" }
      err.call if AOJ::API.problem_search(problem_id) != problem_id
    rescue AOJ::Error::APIError
      err.call
    end

    def read_file(file)
      File.read(file)
      # TODO: errorshori
    end
  end
end
