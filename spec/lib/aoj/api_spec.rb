require "spec_helper"

describe AOJ::API do
  describe 'problem_search' do
    it 'should return valid problem' do
      v = AOJ::API.problem_search('0000').instance_values.symbolize_keys
      expect(v).to eq({
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

  describe 'status_log_search' do
    it 'should return an array of AOJ::Status' do
      problem = AOJ::Problem.new.tap { |p| p.id = '0000' }
      credential = AOJ::Credential.new.tap { |c| c.username = 'na_o_sss' }
      statuses = AOJ::API.status_log_search(problem, credential)
      expect(statuses[0]).to be_a AOJ::Status
    end
  end

  describe 'submit'

  describe 'judge_result' do
    context 'target status exists' do
      it 'should return valid status' do
        module AOJ::API
          def self.status_log_search(problem, credential)
            [
              AOJ::Status.new.tap { |s| s.submission_date = Time.now.ago(15) }
            ]
          end
        end
        status = AOJ::API.judge_result(AOJ::Solution.new, Time.now, nil)
        expect(status).to be_a AOJ::Status
      end
    end

    context 'target status does not exist' do
      it 'should raise error' do
        module AOJ::API
          remove_const :RETRY_SEC
          RETRY_SEC = 1
          def self.status_log_search(problem, credential)
            [
              AOJ::Status.new.tap { |s| s.submission_date = Time.now.ago(45) }
            ]
          end
        end
        expect{AOJ::API.judge_result(AOJ::Solution.new, Time.now, nil)}.to raise_error(AOJ::Error::FetchResultError)
      end
    end
  end

  describe 'loginable?' do
    it 'should return false with invalid credential' do
      credential = AOJ::Credential.new.tap { |c|
        c.username = 'dummy_user'
        c.password = '1111'
      }
      expect(AOJ::API.loginable?(credential)).to be false
    end
  end
end
