require 'net/http'

module AOJ

  HTTP = -> do
    proxy_info = Env.new.parse_proxy_info
    ::Net::HTTP::Proxy(
      proxy_info[:host],
      proxy_info[:port],
      proxy_info[:user],
      proxy_info[:pass]
    )
  end.call
end
