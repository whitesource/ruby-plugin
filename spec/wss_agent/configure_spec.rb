require 'spec_helper'

describe WssAgent::Configure  do
  let(:default_config) {
    {
      'url' => 'http://saas.whitesourcesoftware.com',
      'token'=>'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
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
        expect(WssAgent::Configure.current).to eq({
                                                    'url' => 'http://saas.whitesourcesoftware.com',
                                                    'token' => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
                                                  })
      end
    end
    context 'when locally config is found' do
      before do
        allow(WssAgent::Configure).to receive(:current_path)
                                       .and_return(File.join(File.expand_path('../..', __FILE__), 'fixtures/wss_agent.yml'))
      end
      it 'should return locally config' do
        expect(WssAgent::Configure.current).to eq({
                                                    'url' => 'http://saas.whitesourcesoftware.com',
                                                    'token' => '11111111-1111-1111-1111-111111111112'
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
end
