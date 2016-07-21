module WssAgent
  class Project

    def project_name
      return gem.name if gem?
      return rails_app_name if rails?
      folder_name
    end

    def project_version
      gem? ? gem.version.to_s : ''
    end

    def folder_name
      Bundler.root.split.last.to_s
    end

    def gem?
      !Dir.glob(Bundler.root.join('*.gemspec')).last.nil?
    end

    def gem
      @gem ||= Gem::Specification.load(
        Dir.glob(Bundler.root.join('*.gemspec')).last
      )
    end

    def rails?
      File.exist?(rails_app_path)
    end

    def rails_app_name
      File.read(rails_app_path).match(/module (\w*)/)[1]
    end

    def rails_app_path
      Bundler.root.join('config', 'application.rb')
    end
  end
end
