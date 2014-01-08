require 'spec_helper'

module Producer::Core
  describe Action do
    let(:env)         { double 'env' }
    let(:arguments)   { [:some, :arguments] }
    subject(:action)  { Action.new(env, *arguments) }

    describe '#env' do
      it 'returns the assigned env' do
        expect(action.env).to be env
      end
    end

    describe '#arguments' do
      it 'returns the assigned arguments' do
        expect(action.arguments).to eq arguments
      end
    end

    describe '#output' do
      it 'delegates to env output' do
        expect(action.env).to receive(:output).with(:content)
        action.output :content
      end
    end
  end
end
