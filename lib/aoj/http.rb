require 'net/http'

module AOJ

  HTTP = -> do
    # set proxy if specified
    # [http://][user:pass@]host:port
    env = ENV["HTTP_PROXY"] || ENV["http_proxy"]
    break ::Net::HTTP unless env

    info = parse_proxy_info(env)
    ::Net::HTTP::Proxy(
      info[:host],
      info[:port],
      info[:user],
      info[:pass]
    )
  end.call

  private
  # TODO: test
  def self.parse_proxy_info(str)
    {}.tap do |i|
      str.sub!(/http:\/\//, "")
      str.sub!(/\/+$/, "")
      if str.include?("@")
        auth, str = str.split("@")
        i[:user], i[:pass] = auth.split(":")
      end
      i[:host], port_str = str.split(":")
      i[:port] = port_str.sub(/\//, "").to_i
      i[:uri] = "http://" + str
    end
  end
end
