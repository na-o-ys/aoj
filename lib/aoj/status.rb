module AOJ
  class Status
    attr_accessor :run_id, :user_id, :problem_id, :submission_date, :status, :language, :cputime, :memory, :code_size

    def review_url
      nil unless run_id
      base_url = "http://judge.u-aizu.ac.jp/onlinejudge/review.jsp"
      params = { "rid" => run_id }
      base_url + "?" + params.to_query
    end
  end
end
