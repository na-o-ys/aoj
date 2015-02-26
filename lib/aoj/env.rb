module AOJ
  class Env

    def initialize(env = ENV)
      @env = env
    end

    # parse proxy from String
    # param str : [http://][user:pass@]host[:port]
    def parse_proxy_info
      raw = @env["HTTP_PROXY"] || @env["http_proxy"]
      return {} unless raw

      main_str = raw
        .strip
        .sub(/^http:\/\//, "")
        .sub(/\/+$/, "")

      auth_str = main_str.match(/(.*)@/).to_a[1].to_s
      host_str = main_str.sub(/^.*@/, "")
      {
        host: host_str.sub(/:.*$/, ""),
        port: host_str.match(/:(.*)/).to_a[1].try(:to_i), # int or nil
        user: auth_str.sub(/:.*$/, ""),
        pass: auth_str.sub(/^.*:/, "")
      }.select { |_, value| value.present? }
    end

    def proxy_specified?
      parse_proxy_info != {}
    end

  end
end
