require 'spec_helper'

describe WssAgent::Specifications  do
  before do
    allow(WssAgent::Configure).to receive_messages(token: 'xxxxxx')
  end

  let(:gem_list) {
    [
      {
        'groupId' => 'bacon',
			  'artifactId' => 'bacon-1.2.0.gem',
			  'version' => '1.2.0',
        'sha1' => 'xxxxxxxxxxxxxxxxxxxxxxx',
        'optional' => '',
        'children' => '',
        'exclusions' => ''
      }
    ]
  }

  describe '.check_policies' do
    let(:success_response) {
      "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"TestParallel588\\\",\\\"existingProjects\\\":{\\\"TestProjectUbuntu\\\":{\\\"children\\\":[]}},\\\"newProjects\\\":{},\\\"projectNewResources\\\":{\\\"TestProjectUbuntu\\\":[]}}\"}"
    }

    it 'should check policies' do
      Timecop.freeze(Time.now) do
        stub_request(:post, "http://saas.whitesourcesoftware.com/agent").
          with(:body => {"agent"=>"generic", "agentVersion"=>"1.0", "diff"=>"[{\"coordinates\":{\"artifactId\":\"wss_agent\",\"version\":\"#{WssAgent::VERSION}\"},\"dependencies\":[{\"groupId\":\"bacon\",\"artifactId\":\"bacon-1.2.0.gem\",\"version\":\"1.2.0\",\"sha1\":\"xxxxxxxxxxxxxxxxxxxxxxx\",\"optional\":\"\",\"children\":\"\",\"exclusions\":\"\"}]}]", "product"=>"", "productVersion"=>"", "timeStamp"=>"#{Time.now.to_i}", "token"=>"xxxxxx", "type"=>"CHECK_POLICIES"},
               :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'saas.whitesourcesoftware.com:80', 'User-Agent'=>'Faraday v0.9.1'}).
          to_return(:status => 200, :body => success_response, :headers => {})


        allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)
        expect(capture(:stdout) {WssAgent::Specifications.check_policies}).to eq("All dependencies conform with open source policies\n")
      end
    end
  end

  describe '.update' do

    let(:success_response) {
      "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"Tom Test\\\",\\\"updatedProjects\\\":[],\\\"createdProjects\\\":[]}\"}"
    }
    it 'should update list gems on server' do
      Timecop.freeze(Time.now) do
        stub_request(:post, "http://saas.whitesourcesoftware.com/agent").
          with(:body => {"agent"=>"generic", "agentVersion"=>"1.0", "diff"=>"[{\"coordinates\":{\"artifactId\":\"wss_agent\",\"version\":\"#{WssAgent::VERSION}\"},\"dependencies\":[{\"groupId\":\"bacon\",\"artifactId\":\"bacon-1.2.0.gem\",\"version\":\"1.2.0\",\"sha1\":\"xxxxxxxxxxxxxxxxxxxxxxx\",\"optional\":\"\",\"children\":\"\",\"exclusions\":\"\"}]}]", "product"=>"", "productVersion"=>"", "timeStamp"=>"#{Time.now.to_i}", "token"=>"xxxxxx", "type"=>"UPDATE"},
               :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'saas.whitesourcesoftware.com:80', 'User-Agent'=>'Faraday v0.9.1'}).
          to_return(:status => 200, :body => success_response, :headers => {})


        allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)
        expect(WssAgent::Specifications.update).to be true
      end
    end
  end

  describe '.list' do
    it 'should build list gems'do
      allow_any_instance_of(WssAgent::GemSha1).to receive(:sha1).and_return("85b19b68a33f1dc0e147ff08bad66f7cfc52de36")

      load_specs = double(specs: Bundler::SpecSet.new([Gem::Specification.new('bacon', '1.2.0')]))
      allow(Bundler).to receive(:load).and_return(load_specs)
      expect(WssAgent::Specifications.list).to eq([{"groupId"=>"bacon",
                                                    "artifactId"=>"bacon-1.2.0.gem",
                                                    "version"=>"1.2.0",
                                                    "sha1"=>"85b19b68a33f1dc0e147ff08bad66f7cfc52de36",
                                                    "optional"=>false,
                                                    "children"=>[], "exclusions"=>[]}])
    end
  end

  describe '.specs' do
    it 'load bundle spec' do
      specs_double = double
      expect(specs_double).to receive(:specs).and_return([])
      expect(Bundler).to receive(:load).and_return(specs_double)
      WssAgent::Specifications.specs
    end
  end
end
