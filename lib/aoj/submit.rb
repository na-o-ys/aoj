require "net/http"
require "open-uri"

module AOJ
  module Submit

    class << self

      def check_language(language)
        if language then
          unless Language.languages.include?(language) then
            raise StandardError.new("Language \"" + language.to_s + "\" is unsupported.")
          end
        end
      end

      def submit(solution, language, problem)
        check_language(language) if language

        uri         = Constant[:uri]
        submit_path = Constant[:submit_path]
        data        = create_data(solution, language, problem)

        HTTP.start(uri) { |http|
          response = http.post(submit_path, data)
          print response.code, ' ', response.message, "\n" 
          if response.code.to_i == 200
            return
          end
        }

        raise StandardError.new("Error while submitting.")
      end

      def create_data(solution, language, problem)
        params = {
          :username => Configuration.login_credentials[:username],
          :password => Configuration.login_credentials[:password],

          :problem  => problem,
          :program  => solution,
          :language => Language.map_label_submit_name[language],
        }

        params_enum = params.map do |k, v|
          [Constant[:form_names][k], v]
        end

        URI.encode_www_form(params_enum)
      end

    end
  end
end

