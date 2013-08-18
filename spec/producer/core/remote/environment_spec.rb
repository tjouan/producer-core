require 'spec_helper'

module Producer::Core
  describe Remote::Environment do
    let(:variables)       { { 'FOO' => 'bar', 'BAZ' => 'qux' } }
    subject(:environment) { Remote::Environment.new(variables) }

    describe '#initialize' do
      context 'when a hash is given' do
        it 'assigns the key/value pairs' do
          expect(environment.instance_eval { @variables }).to eq variables
        end
      end

      context 'when a string is given' do
        subject(:environment) { Remote::Environment.new("FOO=bar\nBAZ=qux") }

        it 'assigns the key/value pairs' do
          expect(environment.instance_eval { @variables }).to eq variables
        end
      end
    end

    describe '#has_key?' do
      let(:key) { 'SOME_KEY' }

      it 'forwards the message to @variables' do
        expect(environment.instance_eval { @variables })
          .to receive(:has_key?).with(key)
        environment.has_key? key
      end
    end
  end
end
