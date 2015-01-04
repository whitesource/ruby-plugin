module WssAgent
  class Client

    API_PATH = '/agent'

    attr_accessor :connection

    def initialize
      @connection ||= Faraday.new(url: Configure.url) do |h|
        h.headers[:content_type] = 'application/x-www-form-urlencoded'
        h.request :url_encoded
        h.adapter :excon
      end

      @connection
    end

    def default_params
      {
        type: 'UPDATE',
        agent: 'generic',
        agentVersion: '1.0',
        token: Configure.token
      }
    end

    def diff(gem_list)
      Oj.dump([{
                 dependencies: gem_list,
                 coordinates: {
                   artifactId: 'Demo Project',
                   version: '0.0.1'
                 }
               }])
    end

    def payload(gem_list)
      default_params
        .merge({ timeStamp: Time.now.to_i, diff: diff(gem_list) })
    end

    def request(gem_list)
      Response.new(connection.post(API_PATH, payload(gem_list)))
    rescue Faraday::Error::ClientError => ex
      Response.new(ex)
    end
  end
end
