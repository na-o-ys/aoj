require "spec_helper"

describe AOJ::Conf do
  before { @conf = AOJ::Conf.instance }

  describe 'has_credential?' do
    it 'should return true' do
      @conf['username'] = 'hoge'
      @conf['password'] = 'fuga'
      expect(@conf.has_credential?).to be_truthy
    end

    it 'should return false' do
      @conf['username'] = 'hoge'
      @conf.data.delete 'password'
      expect(@conf.has_credential?).to be_falsy
    end
  end

  describe 'has_twitter_credential?' do
    it 'should return true' do
      @conf['twitter'] = {
        'access_token'        => 'hoge',
        'access_token_secret' => 'fuga'
      }
      expect(@conf.has_twitter_credential?).to be_truthy
    end

    it 'should return false' do
      @conf['twitter'] = { 'access_token' => 'hoge' }
      @conf['twitter'].delete 'access_token_secret'
      expect(@conf.has_twitter_credential?).to be_falsy
    end
  end
end
