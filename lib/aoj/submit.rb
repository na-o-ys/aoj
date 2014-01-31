require "net/http"
require "open-uri"

module AOJ
  module Submit
    extend Configuration

    class << self

      def get_language(filename)
        MAP_EXTNAME_LANGUAGE[File.extname(filename)]
      end

      def get_problem(filename)
        File.basename(filename).split(/[^A-Z0-9]/).first
      end

      def submit(filename, language = nil, problem = nil)
        language ||= get_language(filename)
        problem  ||= get_problem(filename) 

        judge        = AOJ_SETTING
        uri          = judge[:uri]
        path_submit  = judge[:path_submit]
        data         = create_data(filename, language, problem)

        print_log(filename, language, problem)

        Net::HTTP.start(uri) { |http|
          response = http.post(path_submit, data)
          print response.code, ' ', response.message, "\n" 
          if response.code.to_i == 200
            return problem
          end
        }
        nil
      end

      def print_log(filename, language, problem)
        STDERR << "Submitting...\n"

        STDERR << "Problem:  " << problem << "\n"
        STDERR << "Language: " << language.to_s.capitalize << "\n"
        STDERR << "Filename: " << filename << "\n"    
      end

      def create_data(filename, language, problem)
        judge = AOJ_SETTING
        user  = USER_SETTING

        params = {
          :username => user[:username],
          :password => user[:password],

          :problem => problem,
          :program   => File.open(filename).read,
          :language  => judge[:map_form_value_language][language],
        }

        form_name = judge[:map_form_name]

        params.map{ |key, value|
          enc(form_name[key]) + '=' + enc(value)
        }.join('&')
      end

      def enc(str)
        URI.encode(str, /./n)
      end

    end
  end
end

