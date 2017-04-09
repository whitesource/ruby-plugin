module WssAgent
  class ResponseInventory < Response

    def message
      if success?
        @message = "White Source update results: \n"
        @message << "  White Source organization: #{data['organization']} \n"

        if data['createdProjects'].empty?
          @message << "  No new projects found \n"
        else
          @message << "  #{data['createdProjects'].size} newly created projects: "
          @message << data['createdProjects'].join(' ')
        end

        if data['updatedProjects'].empty?
          @message << "\n  No projects were updated \n"
        else
          @message << "  #{data['updatedProjects'].size} existing projects were updated: "
          @message << data['updatedProjects'].join(' ')
        end

        @message
      else
        super
      end
    end
  end
end
