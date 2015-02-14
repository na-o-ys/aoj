module AOJ
  class Problem
    attr_accessor :id, :name, :available, :time_limit, :memory_limit

    def url
      base_url = "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp"
      params = { "id" => id }
      base_url + "?" + params.to_query
    end

    ICPC_VOLUMES = [
      '10', '11', '12', '13', '20', '21', '22', '23', '24', '25', '26'
    ].freeze

    class << self
      def random_icpc(user_id)
        volumes = ICPC_VOLUMES
        solved_ids = AOJ::API.user(user_id)[:solved_list].map { |s| s[:id] }
        volumes.shuffle.each do |volume|
          problem_list = AOJ::API.problem_list(volume).map { |e| e[:id] } - solved_ids
          unless problem_list.empty?
            problem_id = problem_list.sample
            return AOJ::API.problem_search(problem_id)
          end
        end
        raise AOJ::Error::NoProblemLeftError
      end
    end
  end
end
