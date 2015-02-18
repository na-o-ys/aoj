require 'net/http'

module AOJ

  HTTP = -> do
    # set proxy if specified
    env = Env.new
    break ::Net::HTTP unless env.proxy_specified?

    info = env.parse_proxy_info
    ::Net::HTTP::Proxy(
      info[:host],
      info[:port],
      info[:user],
      info[:pass]
    )
  end.call
end
