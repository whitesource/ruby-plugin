require "digest"

module WssAgent
  class Specifications

    class << self
      def specs
        Bundler.load.specs
      end

      def list
        new(specs).call
      end

      def update
        wss_client = WssAgent::Client.new
        result = wss_client.request(WssAgent::Specifications.list)
        if result.success?
          puts "gems has been successfully synced"
        else
          puts "synchronization errors occur: status: #{result.status}, message: #{result.message}"
        end
      end
    end

    def initialize(gem_specs)
      @gem_specs = gem_specs
    end

    def call
      @gem_specs.map do |spec|
        next if spec.name == 'wss_agent'
        gem_item(spec)
      end.compact
    end

    def gem_item(spec)
      {
        'groupId' => spec.name,
			  'artifactId' => spec.file_name,
			  'version' => spec.version.to_s,
        'sha1' => GemSha1.new(spec).sha1,
        'optional' => '',
        'children' => '',
        'exclusions' => ''
      }
    end
  end
end
