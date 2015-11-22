module Producer::Core
  module Tests
    describe HasExecutable, :env do
      subject(:test) { described_class.new(env, executable) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'executable exists' do
          let(:executable) { 'true' }

          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'executable does not exist' do
          let(:executable) { 'some_non_existent_executable' }

          it 'returns false' do
            expect(test.verify).to be false
          end
        end
      end
    end
  end
end
