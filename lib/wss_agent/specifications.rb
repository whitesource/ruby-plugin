require "digest"

module WssAgent
  class Specifications

    def self.list
      new(Bundler.load.specs).call

    end

    def self.sync
      { status: :ok, response: 'success' }
    end

    def initialize(gem_specs)
      @gem_specs = gem_specs
    end

    def call
      @gem_specs.map do |spec|
        next if spec.name == 'wss_agent'
        {
          'groupId' => spec.name,
			    'artifactId' => spec.file_name,
			    'version' => spec.version.to_s,
          'sha1' => gem_sha1(spec),
          'optional' => '',
          'children' => '',
          'exclusions' => ''
        }
      end
    end

    def gem_sha1(spec)
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
      get_remote_file(spec)
    end

    def get_remote_file(spec, retry_request = false)
      uri = URI("http://rubygems.org/gems/#{spec.file_name}")
      response = Net::HTTP.get_response(uri)

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
      retry_request ? nil : get_remote_file(spec, true)
    end
  end
end
