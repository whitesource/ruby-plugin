module WssAgent
  class Response
    SUCCESS_STATUS = 1
    BAD_REQUEST_STATUS = 2
    SERVER_ERROR_STATUS = 3

    attr_reader :response, :status, :message, :response_data, :data

    def initialize(response)
      @response = response
      if response.is_a?(Faraday::Error::ClientError)
        parse_error
      else
        parse_response
      end
    end

    def parse_error
      @status = SERVER_ERROR_STATUS
      @message = response.message
    end

    def parse_response
      if response.success?
        begin
          @response_data = Oj.load(response.body)
          @status = @response_data['status'].to_i
          @message = @response_data['message']
        rescue
          @status = SERVER_ERROR_STATUS
          @message = response.body
        end
      else
        @status = SERVER_ERROR_STATUS
        @message = response.body
      end
    end

    def response_success?
      if response.is_a?(Faraday::Error::ClientError)
        false
      else
        response.success?
      end
    end

    def success?
      response_success? && status == SUCCESS_STATUS
    end

    def data
      @data ||= Oj.load(response_data['data'])
    rescue
      response_data['data']
    end
  end
end
