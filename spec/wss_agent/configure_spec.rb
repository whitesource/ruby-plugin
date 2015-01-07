require 'spec_helper'

describe WssAgent::Configure  do
  let(:default_config) {
    {
      'url' => 'http://saas.whitesourcesoftware.com',
      'type' => 'UPDATE',
      'token'=>'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
      'agent' => 'generic',
      'agent_version' => '1.0',
      'product' => '',
      'product_version' => ''
    }
  }

  describe '.default_path' do
    it 'should return path of default config' do
      expect(WssAgent::Configure.default_path).to match(/\/lib\/config\/default\.yml\Z/)
    end
  end

  describe '.exist_default_config?' do
    it 'should be true' do
      expect(WssAgent::Configure.exist_default_config?).to be true
    end
  end

  describe '.default' do
    it 'should default config' do
      expect(WssAgent::Configure.default).to eq(default_config)
    end
  end

  describe '.current_path' do
    it 'should return locally config path' do
      expect(WssAgent::Configure.current_path).to match(/wss_agent\.yml\Z/)
    end
  end

  describe '.current' do
    context 'when locally config is not found' do
      it 'should return default config' do
        allow(WssAgent::Configure).to receive(:current_path).and_return('miss.yml')
        expect(WssAgent::Configure.current).to eq(default_config)
      end
    end
    context 'when locally config is found' do
      before do
        allow(WssAgent::Configure).to receive(:current_path)
                                       .and_return(File.join(File.expand_path('../..', __FILE__), 'fixtures/wss_agent.yml'))
      end
      it 'should return locally config' do
        expect(WssAgent::Configure.current).to eq({
                                                    "url" => "http://saas.whitesourcesoftware.com",
                                                    "type" => "UPDATE",
                                                    "token" => "11111111-1111-1111-1111-111111111112",
                                                    "agent" => "generic",
                                                    "agent_version" => "1.0",
                                                    "product" => "Test product",
                                                    "product_version" => "1.0.1"
                                                  })
      end
    end
  end

  describe '.url' do
    context 'when url is empty' do
      before do
        allow(WssAgent::Configure).to receive_messages(current: {})
      end
      it 'should cause an exception' do
        expect{ WssAgent::Configure.url }.to raise_error(WssAgent::ApiUrlNotFound)
      end
    end
    context 'when url is exist' do
      it 'should return url' do
        expect(WssAgent::Configure.url).to eq('http://saas.whitesourcesoftware.com')
      end
    end
  end

  describe '.token' do
    context 'when token is not found' do
      it 'should cause an exception' do
        expect{ WssAgent::Configure.token }.to raise_error(WssAgent::TokenNotFound)
      end
    end
    context 'when token is found' do
      let(:config) {
        {
          'url' => 'http://saas.whitesourcesoftware.com',
          'token' => '11111111-1111-1111-1111-111111111111'
        }
      }
      before do
        allow(WssAgent::Configure).to receive_messages(current: config)
      end

      it 'should return token' do
        expect(WssAgent::Configure.token).to eq('11111111-1111-1111-1111-111111111111')
      end
    end
  end

  describe '.type' do
    it 'should be "UPDATE"' do
      expect(WssAgent::Configure['type']).to eq('UPDATE')
    end
  end

  describe '.agent' do
    it 'should be "generic"' do
      expect(WssAgent::Configure['agent']).to eq('generic')
    end
  end

  describe '.agent_version' do
    it 'should be "1.0"' do
      expect(WssAgent::Configure['agent_version']).to eq('1.0')
    end
  end

  describe '.product' do
    before do
      allow(WssAgent::Configure).to receive(:current_path)
                                     .and_return(File.join(File.expand_path('../..', __FILE__), 'fixtures/wss_agent.yml'))
    end

    it 'should be "Test product"' do
      expect(WssAgent::Configure['product']).to eq('Test product')
    end
  end

  describe '.product_version' do
    before do
      allow(WssAgent::Configure).to receive(:current_path)
                                     .and_return(File.join(File.expand_path('../..', __FILE__), 'fixtures/wss_agent.yml'))
    end

    it 'should be "1.0.1"' do
      expect(WssAgent::Configure['product_version']).to eq('1.0.1')
    end
  end
end
