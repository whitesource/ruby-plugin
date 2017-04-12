module WssAgent
  class ResponsePolicies < Response
    REJECT_ACTION = 'Reject'.freeze

    def parse_response
      if response.success?
        begin
          @response_data = MultiJson.load(response.body)
          @status = @response_data['status'].to_i
          @message = @response_data['message']
          check_new_projects
          check_existing_projects
        rescue
          @status = SERVER_ERROR_STATUS
          @message = response.body
        end
      else
        @status = SERVER_ERROR_STATUS
        @message = response.body
      end
    end

    def message
      if success?
        if policy_violations?
          @message = [
            'Some dependencies do not conform with open source policies',
            'List of violations:'
          ]
          @message << policy_violations.each_with_index.map { |j, i|
            "#{i + 1}. Package: #{j['resource']['displayName']} - #{j['policy']['displayName']}"
          }.join("\n")
          @message.join("\n")
        else
          'All dependencies conform with open source policies'
        end
      end
    end

    def policy_violations
      @policy_violations || []
    end

    def policy_violations?
      !policy_violations.nil? &&
        !policy_violations.empty? &&
        policy_violations.size > 0
    end

    def check_existing_projects
      data['existingProjects'].each { |_proj_name, resource| check(resource) }
    end

    def check_new_projects
      data['newProjects'].each { |_proj_name, resource| check(resource) }
    end

    def add_resource(resource)
      @policy_violations ||= []
      @policy_violations << resource
    end

    def check(resource)
      if resource.key?('resource') && resource.key?('policy') &&
         (resource['policy']['actionType'] == REJECT_ACTION)
        add_resource(
          'resource' => resource['resource'],
          'policy' => resource['policy']
        )
      end

      if resource.key?('children') && resource['children'].is_a?(Array)
        resource['children'].each { |j| check(j) }
      end
    end
  end
end
