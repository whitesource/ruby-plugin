require "digest"

module WssAgent
  class GemSha1
    attr_reader :spec

    def initialize(spec)
      @spec = spec
      check_version! unless @spec.version > Gem::Version.new('0')
    end

    # check version
    # if version isn't found get latest version
    #
    def check_version!
      conn = Faraday.new(url: 'https://rubygems.org') do |h|
        h.headers[:content_type] = 'application/x-www-form-urlencoded'
        h.request :url_encoded
        h.adapter :excon
      end
      response = conn.get("/api/v1/versions/#{spec.name}.json")
      versions = Oj.load(response.body)
      unless versions.detect { |j| j['number'] == spec.version }
        spec.version = versions.first['number']
      end
    rescue

    end

    def sha1
      case
      when spec.source.is_a?(Bundler::Source::Rubygems)
        path = spec.source.send(:cached_gem, spec).to_s
        Digest::SHA1.hexdigest(File.read(path))
      when spec.source.is_a?(Bundler::Source::Git)
      # ???
      when spec.source.is_a?(Bundler::Source::Path)
      # ????
      when spec.source.nil?
        remote_file
      end

    rescue => ex
      WssAgent.logger.debug "#{ex.message}"
      WssAgent.logger.debug "#{spec}"
      remote_file
    end

    def remote_file_url
      URI("http://rubygems.org/gems/#{spec.file_name}")
    end

    # download gem from rubygems
    #
    def remote_file(retry_request = false)
      response = Net::HTTP.get_response(remote_file_url)

      case response.code
      when '200' # ok
        Digest::SHA1.hexdigest(response.body)

      when '302' # redirect
        response = Net::HTTP.get_response(URI(response['location']))
        if response.code == '200'
          return Digest::SHA1.hexdigest(response.body)
        end
      else # gem isn't found
        ''
      end

    rescue Timeout::Error
      retry_request ? nil : remote_file(true)
    end

  end
end
