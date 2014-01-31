require "gist"

module AOJ
  module Gist
    def self.post(filename, problem)
      problem_uri = Util.problem_uri(problem)

      program = open(filename).read
      description = "My answer for the problem: #{problem_uri}"
      ::Gist.gist(program, { filename: filename, description: description })
    end
  end
end
