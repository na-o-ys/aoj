module AOJ
  class Credential
    attr_accessor :username, :password

    def valid?
      AOJ::API.loginable?(self)
    end

    def self.get
      Credential.new.tap do |c|
        c.username = AOJ::Conf.instance['username']
        c.password = AOJ::Conf.instance['password']
      end
    end
  end
end
