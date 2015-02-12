require "spec_helper"

describe AOJ::API do
  describe 'problem_search' do
    it 'should return valid XML' do
      expect(AOJ::API.problem_search('0000')).to eq({
        id: '0000',
        name: 'QQ',
        available: true,
        time_limit: 1,
        memory_limit: 65536
      })
    end

    it 'should raise error' do
      expect{AOJ::API.problem_search('114514')}.to raise_error(AOJ::Error::APIError)
    end
  end
end
