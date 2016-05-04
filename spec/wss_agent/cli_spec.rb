require 'spec_helper'

describe WssAgent::CLI, vcr: true  do
  def colorblind(str)
    str.gsub(/\e\[([;\d]+)?m/, '')
  end

  let(:cli) { WssAgent::CLI.new }
  subject { cli }

  context 'config' do
    let(:output) { capture(:stdout) { subject.config } }
    it "should create config file" do
      expect(output).to include("Created the config file: wss_agent.yml")
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

      expect(colorblind(output)).to eq('''[
    [0] {
           "groupId" => "rake",
        "artifactId" => "rake-10.4.2.gem",
           "version" => "10.4.2",
              "sha1" => "abfbf4fe8d3011f13f922adc81167af76890a627",
          "optional" => false,
          "children" => [],
        "exclusions" => []
    },
    [1] {
           "groupId" => "addressable",
        "artifactId" => "addressable-2.3.6.gem",
           "version" => "2.3.6",
              "sha1" => "dc3bdabbac99b05c3f9ec3b066ad1a41b6b55c55",
          "optional" => false,
          "children" => [],
        "exclusions" => []
    }
]
''')
    end
  end

  context 'update' do
    let(:output) { capture(:stdout) { subject.update } }
    context 'when not found token' do
      it 'should display error message' do
        expect(colorblind(output)).to eq("\"Can't find Token, please add your Whitesource API token in the wss_agent.yml file\"\n")
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
