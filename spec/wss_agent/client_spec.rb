require 'spec_helper'

describe WssAgent::Client  do
  let(:bad_request_response) {
    {"envelopeVersion"=>"2.1.0", "status"=>2, "message"=>"Illegal arguments", "data"=>"Unsupported agent: null"}
  }
  let(:success_response) {
    "{\"envelopeVersion\":\"2.1.0\",\"status\":1,\"message\":\"ok\",\"data\":\"{\\\"organization\\\":\\\"Tom Test\\\",\\\"updatedProjects\\\":[],\\\"createdProjects\\\":[]}\"}"
  }
  let(:server_error_response) {
    "<html><head><title>JBoss Web/7.0.13.Final - Error report</title><style><!--H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}HR {color : #525D76;}--></style> </head><body><h1>HTTP Status 500 - </h1><HR size=\"1\" noshade=\"noshade\"><p><b>type</b> Exception report</p><p><b>message</b> <u></u></p><p><b>description</b> <u>The server encountered an internal error () that prevented it from fulfilling this request.</u></p><p><b>exception</b> <pre>java.lang.NullPointerException\n\tcom.wss.service.agent.impl.AgentRequestParams.extractUpdateParams(AgentRequestParams.java:155)\n\tcom.wss.service.agent.impl.AgentRequestParams.fromHttpRequest(AgentRequestParams.java:133)\n\tcom.wss.service.agent.AgentServlet.doPost(AgentServlet.java:71)\n\tjavax.servlet.http.HttpServlet.service(HttpServlet.java:754)\n\tjavax.servlet.http.HttpServlet.service(HttpServlet.java:847)\n</pre></p><p><b>note</b> <u>The full stack trace of the root cause is available in the JBoss Web/7.0.13.Final logs.</u></p><HR size=\"1\" noshade=\"noshade\"><h3>JBoss Web/7.0.13.Final</h3></body></html>"
  }

  let(:wss_client) { WssAgent::Client.new }

  before do
    allow(WssAgent::Configure).to receive_messages(token: 'xxxxxx')
  end


  describe '#payload' do

    it 'should return request params' do
      Timecop.freeze(Time.now) do
        payload = {
          agent: "generic",
          agentVersion: "1.0",
          token: "xxxxxx",
          product: "",
          productVersion: "",
          timeStamp: Time.now.to_i,
          diff: "[{\"coordinates\":{\"artifactId\":\"wss_agent\",\"version\":\"#{WssAgent::VERSION}\"},\"dependencies\":{}}]"
        }

        expect(wss_client.payload({})).to eq(payload)
      end
    end
  end

  describe '#diff' do
    let(:diff) {
      "[{\"coordinates\":{\"artifactId\":\"wss_agent\",\"version\":\"#{WssAgent::VERSION}\"},\"dependencies\":[{\"groupId\":\"bacon\",\"artifactId\":\"bacon-1.2.0.gem\",\"version\":\"1.2.0\",\"sha1\":\"xxxxxxxxxxxxxxxxxxxxxxx\",\"optional\":\"\",\"children\":\"\",\"exclusions\":\"\"}]}]"
    }
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
    it 'should diff of gem list' do
      expect(wss_client.diff(gem_list)).to eq(diff)
    end
  end


  describe '#request' do

    context 'success' do
      before do
        stub_request(:post, "http://saas.whitesourcesoftware.com/agent").
          to_return(status: 200,
                    body: success_response,
                    headers: {})

      end

      subject { wss_client.request(WssAgent::Specifications.list) }

      it 'response should be success' do
        expect(subject).to be_success
      end
      it 'should return message response' do
        expect(subject.message).to eq('ok')
      end
      it 'should return status of response' do
        expect(subject.status).to eq(1)
      end
      it 'should response json data' do
        expect(subject.data).to eq({"organization"=>"Tom Test", "updatedProjects"=>[], "createdProjects"=>[]})
      end
    end

    context 'bad request' do

    end

    context 'server error' do
      before do
        stub_request(:post, "http://saas.whitesourcesoftware.com/agent").
          to_return(status: 200,
                    body: server_error_response,
                    headers: {})

      end
      subject { wss_client.request(WssAgent::Specifications.list) }
      it 'response should be success' do
        expect(subject).to_not be_success
      end
      it 'should return message response' do
        expect(subject.message).to eq(server_error_response)
      end
      it 'should return status of response' do
        expect(subject.status).to eq(WssAgent::Response::SERVER_ERROR_STATUS)
      end
      it 'should response json data' do
        expect(subject.data).to be_nil
      end
    end

    context 'server timeout' do
      before do
        stub_request(:post, "http://saas.whitesourcesoftware.com/agent").
          to_timeout
      end
      subject { wss_client.request(WssAgent::Specifications.list) }
      it 'response should be success' do
        expect(subject).to_not be_success
      end
      it 'should return message response' do
        expect(subject.message).to eq("Excon::Errors::Timeout")
      end
      it 'should return status of response' do
        expect(subject.status).to eq(WssAgent::Response::SERVER_ERROR_STATUS)
      end
      it 'should response json data' do
        expect(subject.data).to be_nil
      end
    end
  end
end
