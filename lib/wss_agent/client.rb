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

    def diff(gem_list)
      Oj.dump([{
                 dependencies: gem_list,
                 coordinates: { artifactId: '', version: '' }
               }])
    end

    def payload(gem_list)
      {
        type: Configure['type'],
        agent: Configure['agent'],
        agentVersion: Configure['agent_version'],
        token: Configure.token,
        product: Configure['product'].to_s,
        productVersion: Configure['product_version'].to_s,
        timeStamp: Time.now.to_i,
        diff: diff(gem_list)
      }
    end

    def request(gem_list)
      Response.new(connection.post(API_PATH, payload(gem_list)))
    rescue Faraday::Error::ClientError => ex
      Response.new(ex)
    end
  end
end
