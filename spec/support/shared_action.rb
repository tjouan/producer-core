module Producer::Core
  shared_examples 'action' do
    include TestEnvHelpers

    let(:arguments)   { [:some, :arguments] }
    let(:options)     { { foo: :bar } }
    subject(:action)  { described_class.new(env, *arguments, options) }

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
  end
end
