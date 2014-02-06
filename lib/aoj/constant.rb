module AOJ
  module Constant

    def self.[](key)
      @hash[key]
    end

    @hash = {
      name: "Aizu Online Judge",
      
      uri:          'judge.u-aizu.ac.jp',
      submit_path:  '/onlinejudge/servlet/Submit',
      result_path:  '/onlinejudge/webservice/status_log',
      problem_path: '/onlinejudge/description.jsp',

      form_names: {
        username: 'userID',
        password: 'password',
        problem:  'problemNO',
        language: 'language',
        program:  'sourceCode'
      }
    }

  end
end
