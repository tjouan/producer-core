require 'spec_helper'

module Producer::Core
  describe Remote::Environment do
    let(:variables)       { { 'FOO' => 'bar', 'BAZ' => 'qux' } }
    let(:string)          { "FOO=bar\nBAZ=qux" }
    let(:argument)        { variables }
    subject(:environment) { Remote::Environment.new(argument) }

    describe '.string_to_hash' do
      it 'converts key=value pairs separated by new lines to a hash' do
        expect(described_class.string_to_hash(string)).to eq variables
      end
    end

    describe '.new_from_string' do
      it 'builds a new instance after converting from string' do
        expect(described_class).to receive(:new).with(variables)
        described_class.new_from_string(string)
      end

      it 'returns the instance' do
        environment = double 'environment'
        allow(described_class).to receive(:new) { environment }
        expect(described_class.new_from_string(string)).to be environment
      end
    end

    describe '#initialize' do
      it 'assigns the key/value pairs' do
        expect(environment.variables).to eq variables
      end
    end

    describe '#key?' do
      let(:key) { 'SOME_KEY' }

      it 'forwards the message to @variables' do
        expect(environment.variables).to receive(:key?).with(key)
        environment.key? key
      end
    end
  end
end
