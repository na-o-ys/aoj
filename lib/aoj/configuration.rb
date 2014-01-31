require "json"

module AOJ
  module Configuration

    MAP_EXTNAME_LANGUAGE = {
      '.c'    => :c,
      '.cpp'  => :cpp,
      '.cc'   => :cpp,
      '.C'    => :cpp,
      '.java' => :java,
      '.rb'   => :ruby
    }

    AOJ_SETTING = {
      :name => "Aizu Online Judge",
      
      :uri         => 'judge.u-aizu.ac.jp',
      :path_submit => '/onlinejudge/servlet/Submit',
      :path_result => '/onlinejudge/webservice/status_log',

      :map_form_name => {
        :username  => 'userID',
        :password  => 'password',
        :problem   => 'problemNO',
        :language  => 'language',
        :program   => 'sourceCode'
      },

      :map_form_value_language => {
        :c    => 'C',
        :cpp  => 'C++',
        :java => 'JAVA',
        :ruby => 'Ruby',
        :cpp11  => 'C++11'
      }
    }

    class << self
      def config
        @config ||= JSON.parse(open(ENV["HOME"] + "/.aoj").read) 
      end

      def get_user_settings
        { 
          username: config["username"],
          password: config["password"]
        }
      end

      def tw_consumer_key
        config["tw_consumer_key"]
      end

      def tw_consumer_secret
        config["tw_consumer_secret"]
      end

      def tw_access_token
        config["tw_access_token"]
      end

      def tw_access_token_secret
        config["tw_access_token_secret"]
      end

    end

    USER_SETTING = get_user_settings

  end
end
