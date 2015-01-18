module WssAgent
  class Client

    attr_accessor :connection
    CHECK_POLICIES_TYPE = 'CHECK_POLICIES'
    REQUEST_TIMEOUT = 120

    def initialize
      @connection ||= Faraday.new(Configure.url, { request: { timeout: REQUEST_TIMEOUT } }) do |h|
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

    def payload(gem_list, options = {})
      {
        agent: Configure['agent'],
        agentVersion: Configure['agent_version'],
        token: Configure.token,
        product: Configure['product'].to_s,
        productVersion: Configure['product_version'].to_s,
        timeStamp: Time.now.to_i,
        diff: diff(gem_list)
      }.merge(options)
    end

    def update(gem_list)
      request(gem_list, { type: Configure['type'] })
    end

    def check_policies(gem_list)
      request(gem_list, { type: CHECK_POLICIES_TYPE })
    end

    def request(gem_list, options = {})
      WssAgent.logger.debug "request params: #{payload(gem_list, options)}"

      Response.new(connection.post(WssAgent::Configure.api_path, payload(gem_list, options)))
    rescue Faraday::Error::ClientError => ex
      Response.new(ex)
    end
  end
end
