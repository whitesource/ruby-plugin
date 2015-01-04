require "digest"

module WssAgent
  class GemSha1
    attr_reader :spec

    def initialize(spec)
      @spec = spec
    end

    def sha1
      case
      when spec.source.is_a?(Bundler::Source::Rubygems)
        path = spec.source.send(:cached_gem, spec).to_s
        Digest::SHA1.hexdigest(File.read(path))
      when spec.source.is_a?(Bundler::Source::Git)
        path = spec.source.send(:cached_gem, spec).to_s
        Digest::SHA1.hexdigest(File.read(path))
      when spec.source.is_a?(Bundler::Source::Path)
        # ????
      end

    rescue => ex
      if ENV['DEBUG']
        puts ex
        puts spec
      end
      remote_file
    end

    def remote_file_url
      URI("http://rubygems.org/gems/#{spec.file_name}")
    end

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
