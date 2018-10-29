module WssAgent
  # Client class
  #
  class Client
    attr_accessor :connection
    POLICY_TYPES = {
      basic: 'CHECK_POLICIES',
      compliance: 'CHECK_POLICY_COMPLIANCE'
    }.freeze

    UPDATE_TYPE = 'UPDATE'.freeze
    REQUEST_TIMEOUT = 120
    RECONNECT_RETRIES = 1
    RECONNECT_INTERVAL = 3


    def initialize
      @connection ||= Faraday.new(connection_options) do |h|
        h.port = Configure.port
        h.headers[:content_type] = 'application/x-www-form-urlencoded'
        h.request :url_encoded
        h.adapter :excon
      end
      Excon.defaults[:ciphers] = 'DEFAULT' if defined?(JRuby)

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
      MultiJson.dump([diff_data])
    end

    def payload(gem_list, options = {})
      req_options = {
        agent: Configure['agent'],
        agentVersion: Configure['agent_version'],
        token: Configure.token,
        product: Configure['product'].to_s,
        productVersion: Configure['product_version'].to_s,
        timeStamp: Time.now.to_i,
        diff: diff(gem_list)
      }
      req_options[:userKey] = Configure.user_key if Configure.user_key?
      req_options.merge(options)
    end

    def update(gem_list)
      ResponseInventory.new(request(gem_list, type: UPDATE_TYPE))
    end

    def check_policies(gem_list, options = {})
      request_options =
        if Configure['force_check_all_dependencies'] || options['force']
          { type: POLICY_TYPES[:compliance], forceCheckAllDependencies: true }
        else
          { type: POLICY_TYPES[:basic], forceCheckAllDependencies: false }
        end

      ResponsePolicies.new(request(gem_list, request_options))
    end

    def request(gem_list, options = {})
      WssAgent.logger.debug "request params: #{payload(gem_list, options)}"

      retries = Configure['retries'] ? Configure['retries'] : RECONNECT_RETRIES
      interval = Configure['interval']? Configure['interval'] : RECONNECT_INTERVAL

      while(retries > 0)
        begin
          return connection.post(Configure.api_path, payload(gem_list, options))
        rescue Faraday::Error::ClientError => ex
          retries = retries - 1
          WssAgent.logger.error "Failed to send request to WhiteSource server: #{ex}"
          if(retries > 0)
            WssAgent.logger.error "Trying to connect to WhiteSource server again. sleeping #{interval} seconds..."
            sleep(interval)
          else
            return ex
          end
        end
      end
    end

    private

    def connection_options
      @connection_options ||
        begin
          @connection_options = {
            url: Configure.url, request: { timeout: REQUEST_TIMEOUT }
          }
          @connection_options[:ssl] = ssl_options if Configure.ssl?
        end
      @connection_options
    end

    def ssl_options
      { ca_file: WssAgent::DEFAULT_CA_BUNDLE_PATH }
    end
  end
end
