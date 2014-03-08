require 'spec_helper'

module Producer::Core
  module Tests
    describe ShellCommandStatus, :env do
      let(:command)   { 'true' }
      subject(:test)  { described_class.new(env, command) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'command return status is 0' do
          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'command return status is not 0' do
          let(:command) { 'false' }

          it 'returns false' do
            expect(test.verify).to be false
          end
        end
      end

      describe '#command' do
        it 'returns the first argument' do
          expect(test.command).to eq command
        end
      end
    end
  end
end
