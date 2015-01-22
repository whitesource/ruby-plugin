require 'spec_helper'

describe WssAgent::CLI, vcr: true  do

  let(:cli) { WssAgent::CLI.new }
  subject { cli }

  context 'config' do
    let(:output) { capture(:stdout) { subject.config } }
    it "should create config file" do
      expect(output).to include("created config file: wss_agent.yml")
    end
  end

  context 'list' do
    let(:output) { capture(:stdout) { subject.list } }
    let(:list) {
      [
        {"groupId"=>"rake", "artifactId"=>"rake-10.4.2.gem", "version"=>"10.4.2", "sha1"=>"abfbf4fe8d3011f13f922adc81167af76890a627", "optional"=>false, "children"=>[], "exclusions"=>[]},
        {"groupId"=>"addressable", "artifactId"=>"addressable-2.3.6.gem", "version"=>"2.3.6", "sha1"=>"dc3bdabbac99b05c3f9ec3b066ad1a41b6b55c55", "optional"=>false, "children"=>[], "exclusions"=>[]}]
    }
    it "returns a list dependies" do
      expect(WssAgent::Specifications).to receive(:list).and_return(list)

      expect(output).to eq("[\n    \e[1;37m[0] \e[0m{\n           \"groupId\"\e[0;37m => \e[0m\e[0;33m\"rake\"\e[0m,\n        \"artifactId\"\e[0;37m => \e[0m\e[0;33m\"rake-10.4.2.gem\"\e[0m,\n           \"version\"\e[0;37m => \e[0m\e[0;33m\"10.4.2\"\e[0m,\n              \"sha1\"\e[0;37m => \e[0m\e[0;33m\"abfbf4fe8d3011f13f922adc81167af76890a627\"\e[0m,\n          \"optional\"\e[0;37m => \e[0m\e[1;31mfalse\e[0m,\n          \"children\"\e[0;37m => \e[0m[],\n        \"exclusions\"\e[0;37m => \e[0m[]\n    },\n    \e[1;37m[1] \e[0m{\n           \"groupId\"\e[0;37m => \e[0m\e[0;33m\"addressable\"\e[0m,\n        \"artifactId\"\e[0;37m => \e[0m\e[0;33m\"addressable-2.3.6.gem\"\e[0m,\n           \"version\"\e[0;37m => \e[0m\e[0;33m\"2.3.6\"\e[0m,\n              \"sha1\"\e[0;37m => \e[0m\e[0;33m\"dc3bdabbac99b05c3f9ec3b066ad1a41b6b55c55\"\e[0m,\n          \"optional\"\e[0;37m => \e[0m\e[1;31mfalse\e[0m,\n          \"children\"\e[0;37m => \e[0m[],\n        \"exclusions\"\e[0;37m => \e[0m[]\n    }\n]\n")

    end
  end

  context 'update' do
    let(:output) { capture(:stdout) { subject.update } }
    context 'when not found token' do
      it 'should display error message' do
        expect(output).to eq("\e[0;33m\"Can't find Token, please make sure you input your whitesource API token in the wss_agent.yml file.\"\e[0m\n")
      end
    end
    it 'should display results' do
      expect(WssAgent::Specifications).to receive(:update).and_return([])
      expect(output).to eq("")
    end
  end

  context 'check_policies' do
    let(:output) { capture(:stdout) { subject.check_policies } }
    it 'should display results' do
      expect(WssAgent::Specifications).to receive(:check_policies).and_return([])
      expect(output).to eq("")
    end
  end

  context 'version' do
    let(:output) { capture(:stdout) { subject.version } }
    it 'should display version' do
      expect(output).to eq("#{WssAgent::VERSION}\n")
    end
  end
end
