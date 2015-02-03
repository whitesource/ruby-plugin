require 'thor'
require 'net/http'
require 'awesome_print'
require 'yaml'
require 'oj'
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
  # Your code goes here...

  class WssAgentError < StandardError
    def self.status_code(code)
      define_method(:status_code) { code }
    end
  end

  class NotFoundConfigFile  < WssAgentError; status_code(8) ; end
  class InvalidConfigFile   < WssAgentError; status_code(9) ; end
  class TokenNotFound       < WssAgentError; status_code(10) ; end
  class ApiUrlNotFound      < WssAgentError; status_code(11) ; end
  class ApiUrlInvalid       < WssAgentError; status_code(12) ; end

  def self.logger
    @logger ||= Yell.new STDOUT, level: [:info]
  end

  def self.enable_debug!
    @logger ||= Yell.new STDOUT, level: [:debug, :info, :warn, :error, :fatal, :unknown]
  end
end
