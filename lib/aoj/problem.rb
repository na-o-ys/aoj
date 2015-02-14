module AOJ
  class Problem
    attr_accessor :id, :name, :available, :time_limit, :memory_limit

    def url
      base_url = "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp"
      params = { "id" => id }
      base_url + "?" + params.to_query
    end
  end
end
