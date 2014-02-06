require "net/http"
require "open-uri"

module AOJ
  module Submit

    class << self

      def get_language(filename)
        Language.map_extname_label[File.extname(filename)]
      end

      def get_problem(filename)
        File.basename(filename).split(/[^A-Z0-9]/).first
      end

      def submit(filename, language = nil, problem = nil)
        language ||= get_language(filename)
        problem  ||= get_problem(filename) 

        uri          = Constant[:uri]
        path_submit  = Constant[:submit_path]
        data         = create_data(filename, language, problem)

        print_log(filename, language, problem)

        proxy_former, proxy_latter = (ENV["http_proxy"] || '').sub(/http:\/\//, '').split('@')
        if proxy_latter == nil then
          proxy_host, proxy_port = proxy_former.split(':')
        else
          proxy_user, proxy_pass = proxy_former.split(':')
          proxy_host, proxy_port = proxy_latter.split(':')
        end

        Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_pass).start(uri) { |http|
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
        params = {
          :username => Configuration.login_credentials[:username],
          :password => Configuration.login_credentials[:password],

          :problem  => problem,
          :program  => File.open(filename).read,
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

