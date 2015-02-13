require "spec_helper"

describe AOJ::Language do
  describe 'find' do
    it 'should return valid language' do
      l = AOJ::Language.find(:cpp)
      expect(l.key).to eq(:cpp)
      expect(l.submit_name).to eq("C++")
    end
  end

  describe 'find_by_ext' do
    it 'should return valid language' do
      l = AOJ::Language.find_by_ext(".rb")
      expect(l.key).to eq(:ruby)
      expect(l.submit_name).to eq("Ruby")
    end
  end
end
