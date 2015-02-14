require "yaml"
require "forwardable"

module AOJ
  class Conf
    include Singleton
    extend Forwardable
    RCFILE = ".aojrc"

    def_delegators :@data, :[], :[]=
    attr_accessor :data

    def initialize
      @data = load_file
    end

    def rcfile_path
      File.join(Dir.home, RCFILE)
    end

    def load_file
      YAML.load_file rcfile_path
    rescue Errno::ENOENT
      {}
    end

    def save
      open(rcfile_path, "w", 0600) do |file|
        file.write @data.to_yaml
      end
    end

    def has_credential?
      self['username'] and self['password']
    end

    def has_twitter_credential?
      (twitter = self['twitter']) and
        twitter['access_token'] and twitter['access_token_secret']
    end
  end
end
