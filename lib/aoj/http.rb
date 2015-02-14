require "open-uri"

module AOJ

  # class HTTP < Net::HTTP
  HTTP = -> do
    # set proxy if specified
    # [http://][user:pass@]host:port
    env = ENV["HTTP_PROXY"] || ENV["http_proxy"]
    break Net::HTTP unless env

    info = parse_proxy_info(env)
    Net::HTTP::Proxy(
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

  # module HTTP
  #   def self.proxy_info
  #     return @info if @info
  #     return @info = {} unless env = ENV["HTTP_PROXY"] || ENV["http_proxy"]

  #     info = {}
  #     env = env.sub(/http:\/\//, "")
  #     if env.include?("@")
  #       auth, env = env.split("@")
  #       info[:user], info[:pass] = auth.split(":")
  #     end
  #     info[:host], port_str = env.split(":")
  #     info[:port] = port_str.sub(/\//, "").to_i
  #     info[:uri] = "http://" + env

  #     @info = info
  #   end

  #   def self.start(uri, &block)
  #     Net::HTTP::Proxy(proxy_info[:host], proxy_info[:port], 
  #                      proxy_info[:user], proxy_info[:pass]).start(uri, &block)
  #   end

  #   def self.open(uri)
  #     return Kernel.open(uri) if proxy_info.empty?

  #     option = if proxy_info[:user]
  #                { proxy_http_basic_authentication: 
  #                  [proxy_info[:host], proxy_info[:port], 
  #                    proxy_info[:user], proxy_info[:pass]]}
  #              else
  #                { proxy: proxy_info[:uri] }
  #              end

  #     Kernel.open(uri, option)
  #   end
  # end
end
