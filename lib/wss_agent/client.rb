module WssAgent
  class Client

    attr_accessor :connection
    CHECK_POLICIES_TYPE = 'CHECK_POLICIES'
    UPDATE_TYPE = 'UPDATE'
    REQUEST_TIMEOUT = 120

    def initialize
      @connection ||= Faraday.new(connection_options) do |h|
        h.port = Configure.port
        h.headers[:content_type] = 'application/x-www-form-urlencoded'
        h.request :url_encoded
        h.adapter :excon
      end

      @connection
    end

    def diff(gem_list)
      diff_data = {
        'coordinates' => Configure.coordinates,
        'dependencies' => gem_list
      }
      if Configure['project_token']
        diff_data['projectToken'] = Configure['project_token']
      end
      Oj.dump([diff_data])
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
      ResponseInventory.new(request(gem_list, { type: UPDATE_TYPE }))
    end

    def check_policies(gem_list)
      ResponsePolicies.new(request(gem_list, { type: CHECK_POLICIES_TYPE }))
    end

    def request(gem_list, options = {})
      WssAgent.logger.debug "request params: #{payload(gem_list, options)}"

      connection.post(WssAgent::Configure.api_path, payload(gem_list, options))
    rescue Faraday::Error::ClientError => ex
      ex
    end

    private

    def connection_options
      @connection_options ||
        begin

          @connection_options = {
            url: Configure.url,
            request: { timeout: REQUEST_TIMEOUT }
          }
          if Configure.ssl?
            @connection_options[:ssl] = {
              ca_file: WssAgent::DEFAULT_CA_BUNDLE_PATH
            }
          end
        end
      @connection_options
    end
  end
end
