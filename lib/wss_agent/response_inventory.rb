module WssAgent
  class ResponseInventory < Response

    def message
      if success?
        @message = "White Source update results: \n"
        @message << "  White Source organization: #{data['organization']} \n"

        unless data['createdProjects'].empty?
          @message << "  #{data['createdProjects'].size} newly created projects: "
          @message << data['createdProjects'].join(' ')
        else
          @message << "  No new projects found \n"
        end

        unless data['updatedProjects'].empty?
          @message << "  #{data['updatedProjects'].size}  existing projects were updated: "
          @message << data['updatedProjects'].join(' ')
        else
          @message << "\n  No projects were updated \n"
        end
        @message
      else
        super
      end
    end
  end
end
