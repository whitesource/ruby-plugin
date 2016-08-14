require 'spec_helper'

describe WssAgent::Specifications, vcr: true do
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
      WssAgent::ResponsePolicies.new(
        Faraday::Response.new(
        body:
          "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"TestParallel588\\\",\\\"existingProjects\\\":{\\\"TestProjectUbuntu\\\":{\\\"children\\\":[]}},\\\"newProjects\\\":{},\\\"projectNewResources\\\":{\\\"TestProjectUbuntu\\\":[]}}\"}",
        status: 200))
    }

    it 'should check policies' do
      Timecop.freeze(Time.now) do
        allow_any_instance_of(WssAgent::Client).to receive(:check_policies)
                                                    .and_return(success_response)

        allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)
        expect(capture(:stdout) {WssAgent::Specifications.check_policies}).to eq("All dependencies conform with open source policies\n")
      end
    end
  end

  describe '.update' do
    let(:wss_client) { WssAgent::Client.new }
    let(:success_response) {
      WssAgent::ResponseInventory.new(
        Faraday::Response.new(
        body:
          "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"Tom Test\\\",\\\"updatedProjects\\\":[],\\\"createdProjects\\\":[]}\"}",
        status: 200))
    }
    let(:policy_success_response) {
      WssAgent::ResponsePolicies.new(
        Faraday::Response.new(
        body:
          "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"TestParallel588\\\",\\\"existingProjects\\\":{\\\"TestProjectUbuntu\\\":{\\\"children\\\":[]}},\\\"newProjects\\\":{},\\\"projectNewResources\\\":{\\\"TestProjectUbuntu\\\":[]}}\"}",
        status: 200))
    }

    it 'should update list gems on server' do
      Timecop.freeze(Time.now) do
        allow_any_instance_of(WssAgent::Client).to receive(:update)
                                                    .and_return(success_response)
        allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)
        res = WssAgent::Specifications.update
        expect(res.success?).to be true
      end
    end

    context 'when check_policies is true' do

      before {
        allow(WssAgent::Client).to receive(:new).and_return(wss_client)
        allow(WssAgent::Configure).to receive(:current)
                                       .and_return(WssAgent::Configure.default.merge({'check_policies' => true}))
      }
      context 'and check policies return a violation' do
        it 'should not update inventory' do
          allow(policy_success_response).to receive(:policy_violations?).and_return(true)
          expect(wss_client).to receive(:check_policies).and_return(policy_success_response)
          expect(wss_client).to_not receive(:update)
          res = WssAgent::Specifications.update
          expect(res.success?).to be false
        end
      end

      context 'and check policies returns without a violation' do
        it 'should update inventory' do
          allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)
          allow(policy_success_response).to receive(:policy_violations?).and_return(false)
          expect(wss_client).to receive(:check_policies).and_return(policy_success_response)
          expect(wss_client).to receive(:update).and_return(success_response)

          res = WssAgent::Specifications.update
          expect(res.success?).to be true
        end
      end
    end

    context 'when check_policies is false' do
      before {
        allow(WssAgent::Client).to receive(:new).and_return(wss_client)
        allow(WssAgent::Configure).to receive(:current)
                                       .and_return(WssAgent::Configure.default.merge({'check_policies' => false}))
      }
      it 'should update inventory' do
        allow(WssAgent::Specifications).to receive(:list).and_return(gem_list)

        expect(wss_client).to_not receive(:check_policies)
        expect(wss_client).to receive(:update).and_return(success_response)

        res = WssAgent::Specifications.update
        expect(res.success?).to be true
      end
    end
  end

  describe '.list' do
    it 'should build list gems'do
      allow_any_instance_of(WssAgent::GemSha1).to receive(:sha1).and_return("85b19b68a33f1dc0e147ff08bad66f7cfc52de36")

      load_specs = double(specs: Bundler::SpecSet.new([Gem::Specification.new('bacon', '1.2.0')]))
      allow(Bundler::Definition).to receive(:build).and_return(load_specs)
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
      expect(Bundler::Definition).to receive(:build).and_return(specs_double)
      WssAgent::Specifications.specs
    end
  end
end
