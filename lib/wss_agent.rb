require 'thor'
require 'net/http'
require 'awesome_print'
require 'psych'
require 'multi_json'
require 'faraday'
require 'faraday_middleware'
require 'yell'
require 'wss_agent/version'
require 'wss_agent/specifications'
require 'wss_agent/configure'
require 'wss_agent/cli'
require 'wss_agent/response'
require 'wss_agent/response_policies'
require 'wss_agent/response_inventory'
require 'wss_agent/client'
require 'wss_agent/gem_sha1'
require 'wss_agent/project'

module WssAgent
  DEFAULT_CA_BUNDLE_PATH = File.dirname(__FILE__) + '/data/ca-certificates.crt'

  class WssAgentError < StandardError
    URL_INVALID = 'Api url is invalid. Could you please check url in wss_agent.yml'.freeze
    CANNOT_FIND_TOKEN = "Can't find Token, please add your Whitesource API token in the wss_agent.yml file".freeze
    CANNOT_FIND_URL = "Can't find the url, please add your Whitesource url destination in the wss_agent.yml file.".freeze
    INVALID_CONFIG_FORMAT = 'Problem reading wss_agent.yml, please check the file is a valid YAML'.freeze
    NOT_FOUND_CONFIGFILE = "Config file isn't exist. Could you please run 'wss_agent config' before.".freeze

    def self.status_code(code)
      define_method(:status_code) { code }
    end
  end

  class NotFoundConfigFile  < WssAgentError; status_code(8); end
  class InvalidConfigFile   < WssAgentError; status_code(9); end
  class TokenNotFound       < WssAgentError; status_code(10); end
  class ApiUrlNotFound      < WssAgentError; status_code(11); end
  class ApiUrlInvalid       < WssAgentError; status_code(12); end

  def self.logger
    @logger ||= Yell.new STDOUT, level: [:info]
  end

  def self.enable_debug!
    @logger ||= Yell.new(
      STDOUT, level: [:debug, :info, :warn, :error, :fatal, :unknown]
    )
  end
end
