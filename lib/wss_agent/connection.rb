module WssAgent
  class Connection
    attr_accessor :connection

    def initialize(adapter = Faraday.default_adapter)
      @connection = adapter
    end
  end
end
