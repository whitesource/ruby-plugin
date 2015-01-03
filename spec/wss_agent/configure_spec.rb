require 'spec_helper'

describe WssAgent::Configure  do
  let(:default_config) {
    {
      'url' => 'http://saas.whitesourcesoftware.com',
      'token'=>'f6f2d82b-de26-4cc0-8536-48679d2224c8'
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
    it 'should return locally config path'
  end

  describe '.current' do
    context 'when locally config is not found' do
      it 'should return default config'
    end
    context 'when locally config is found' do
      it 'should return locally config'
    end
  end

  describe '.url' do
    context 'when url is empty' do
      it 'should cause an exception'
    end
    context 'when url is exist' do
      it 'should return url'
    end
  end

  describe '.token' do
    context 'when token is not found' do
      it 'should cause an exception'
    end
    context 'when token is found' do
      it 'should return token'
    end
  end
end
