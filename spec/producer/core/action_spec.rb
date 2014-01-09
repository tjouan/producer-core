require 'spec_helper'

module Producer::Core
  describe Action do
    let(:output)      { StringIO.new }
    let(:env)         { Env.new(output: output) }
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
        action.output.puts 'some content'
        expect(output.string).to eq "some content\n"
      end
    end

    describe '#remote' do
      it 'returns env remote' do
        expect(action.remote).to be action.env.remote
      end
    end
  end
end
