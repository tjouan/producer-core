module Producer::Core
  shared_examples 'action' do
    include TestEnvHelpers

    let(:arguments)   { [:some, :arguments] }
    subject(:action)  { described_class.new(env, *arguments) }

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

    describe '#input' do
      it 'returns env input' do
        expect(action.input).to be env.input
      end
    end

    describe '#output' do
      it 'returns env output' do
        expect(action.output).to be env.output
      end
    end

    describe '#error_output' do
      it 'returns env error output' do
        expect(action.error_output).to be env.error_output
      end
    end

    describe '#remote' do
      it 'returns env remote' do
        expect(action.remote).to be env.remote
      end
    end

    describe '#fs' do
      it 'returns env remote fs' do
        expect(action.fs).to be env.remote.fs
      end
    end

    describe '#name' do
      it 'returns a word' do
        expect(action.name).to match /\A\w+\z/
      end
    end

    describe '#to_s' do
      it 'includes action name' do
        expect(action.to_s).to match /\A#{action.name}/
      end

      it 'includes arguments inspection' do
        expect(action.to_s).to match /#{Regexp.quote(arguments.inspect)}\z/
      end

      context 'when arguments inspection is very long' do
        let(:arguments)   { [:some, :arguments] * 32 }

        it 'summarizes arguments inspection' do
          expect(action.to_s.length).to be < 70
        end
      end
    end
  end
end
