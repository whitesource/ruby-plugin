require 'spec_helper'

describe WssAgent::Specifications  do

  describe '.sync' do
    it 'should sync list gems with server'
  end

  describe '.list' do
    it 'should build list gems'
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
