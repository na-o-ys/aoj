module AOJ
  module CLI::Helper
    def detect_language(file, opt)
      if opt
        AOJ::Language.find(opt.to_sym)
      else
        AOJ::Language.find_by_ext(File.extname(file))
      end.tap { |l|
        unless l
          raise AOJ::Error::LanguageDetectionError, "Failed to detect language, check `aoj languages`"
        end
      }
    end

    def detect_problem(file, opt)
      API.problem_search(opt || File.basename(file, ".*"))
    end

    def read_file(file)
      File.read(file)
    rescue
      raise AOJ::Error::FileOpenError, "Failed to open source file (#{file})"
    end
  end
end
