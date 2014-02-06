require "open-uri"

module AOJ
  module HTTP
    def self.proxy_info
      return @info if @info
      return @info = {} unless env = ENV["HTTP_PROXY"] || ENV["http_proxy"]

      info = {}
      env = env.sub(/http:\/\//, "")
      if env.include?("@")
        auth, env = env.split("@")
        info[:user], info[:path] = auth.split(":")
      end
      info[:host], port_str = env.split(":")
      info[:port] = port_str.sub(/\//, "").to_i
      info[:uri] = "http://" + env

      @info = info
    end

    def self.start(uri, &block)
      Net::HTTP::Proxy(proxy_info[:host], proxy_info[:port], 
                       proxy_info[:user], proxy_info[:pass]).start(uri, &block)
    end

    def self.open(uri)
      return Kernel.open(uri) if proxy_info.empty?

      option = if proxy_info[:user]
                 { proxy_http_basic_authentication: 
                   [proxy_info[:host], proxy_info[:port], 
                     proxy_info[:user], proxy_info[:pass]]}
               else
                 { proxy: proxy_info[:uri] }
               end

      Kernel.open(uri, option)
    end
  end
end
