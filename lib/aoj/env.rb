module AOJ
  class Env

    def initialize(env = ENV)
      @uri = env["HTTP_PROXY"] || env["http_proxy"]
      @uri = @uri.dup
    end

    # parse proxy from String
    # param str : [http://][user:pass@]host:port
    def parse_proxy_info
      {}.tap do |i|
        @uri.sub!(/http:\/\//, "")
        @uri.sub!(/\/+$/, "")
        if @uri.include?("@")
          auth, @uri = @uri.split("@")
          i[:user], i[:pass] = auth.split(":")
        end
        i[:host], port_str = @uri.split(":")
        i[:port] = port_str.sub(/\//, "").to_i
        i[:uri] = "http://" + @uri
      end
    end

    def proxy_specified?
      !!@uri
    end

  end
end
