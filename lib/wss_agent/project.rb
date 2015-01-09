module WssAgent
  class Project

    def project_name
      case
      when is_gem?
        gem.name
      when is_rails_app?
        rails_app_name
      else
        folder_name
      end
    end

    def project_version
      case
      when is_gem?
        gem.version.to_s
      else
        '0.0.0'
      end
    end

    def folder_name
      Bundler.root.split.last.to_s
    end

    def is_gem?
      !Dir.glob(Bundler.root.join('*.gemspec')).last.nil?
    end

    def gem
      @gem ||= Gem::Specification.load(Dir.glob(Bundler.root.join('*.gemspec')).last)
    end

    def is_rails_app?
      !Dir.glob(Bundler.root.join('config', 'application.rb')).last.nil?
    end

    def rails_app_name
      application_file = File.read(Dir.glob(Bundler.root.join('config', 'application.rb')).last)
      application_file.match(/module (\w*)/) && $1
    end
  end
end
