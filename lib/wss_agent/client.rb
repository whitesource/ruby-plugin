module WssAgent
  class Client

    attr_accessor :connection

    def initialize
      @connection ||= Faraday.new(url: Configure.url) do |h|
        h.port = Configure.port
        h.headers[:content_type] = 'application/x-www-form-urlencoded'
        h.request :url_encoded
        h.adapter :excon
      end

      @connection
    end

    def diff(gem_list)
      Oj.dump([{
                 'coordinates' => Configure.coordinates,
                 'dependencies' => gem_list
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
      WssAgent.logger.debug "request params: #{payload(gem_list)}"

      Response.new(connection.post(WssAgent::Configure.api_path, payload(gem_list)))
    rescue Faraday::Error::ClientError => ex
      Response.new(ex)
    end
  end
end
