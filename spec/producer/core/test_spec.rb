require 'spec_helper'

module Producer::Core
  describe Test do
    let(:env)         { double 'env' }
    let(:arguments)   { [:some, :arguments] }
    subject(:action)  { Test.new(env, *arguments) }

    describe '#initialize' do
      it 'assigns the env' do
        expect(action.instance_eval { @env }).to be env
      end
      it 'assigns the arguments' do
        expect(action.instance_eval { @arguments }).to eq arguments
      end
    end

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
  end
end
