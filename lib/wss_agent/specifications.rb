require "digest"

module WssAgent
  class Specifications

    class << self
      # Get dependencies
      #
      def specs(options = {})
        list_gems = Bundler.load.specs.to_a
        if options['all']
          # get all gems
          list = {}
          list_gems.each { |j| list[j.name] = j }
          list_gems.each { |j|
            list = gem_dependencies(list, j.dependencies, options)
          }

          list_gems = list.values
        end
        list_gems
      end

      # Display list dependencies
      #
      def list(options = {})
        new(specs(options)).call
      end

      # Send gem list to server
      #
      def update(options = {})
        wss_client = WssAgent::Client.new
        result = wss_client.request(WssAgent::Specifications.list(options))
        if result.success?
          puts "gems has been successfully synced"
        else
          puts "synchronization errors occur: status: #{result.status}, message: #{result.message}"
        end
        result.success?
      end

      # Get all dependencies includes development
      #
      def gem_dependencies(list, gem_dependencies, options = {})
        gem_dependencies.each do |gd|
          if options['excludes'] && options['excludes'].to_s.split(',').include?(gd.name)
            next
          end
          gs = gd.matching_specs.first
          if gs
            unless list[gs.name]
              list[gs.name] = gs
              unless gs.dependencies.empty?
                list = gem_dependencies(list, gs.dependencies, options)
              end
            end
          else
            unless list[gd.name]
              list[gd.name] = Gem::Specification.new(gd.name,
                                                     gd.requirements_list.last.scan(/[\d\.\w]+/).first)
              rm_dep = remote_dependencies(gd.name, gd.requirements_list.last)
              unless rm_dep.empty?
                list = gem_dependencies(list, rm_dep, options)
              end
            end
          end
        end

        list
      end

      # Load dependencies from rubygems
      #
      def remote_dependencies(gem_name, version)
        conn = Faraday.new(url: 'https://rubygems.org') do |h|
          h.headers[:content_type] = 'application/x-www-form-urlencoded'
          h.request :url_encoded
          h.adapter :excon
        end
        response = conn.get("/api/v1/gems/#{gem_name}.json")
        dep_list = Oj.load(response.body)
        dep_list['dependencies'].values.flatten.
          map { |j| Gem::Dependency.new(j['name'], Gem::Requirement.new(j['requirements'].split(','))) }
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
