require 'spec_helper'

module Producer
  module Core
    describe ErrorFormatter do
      let(:debug)         { false }
      let(:force_cause)   { [] }
      let(:options)       { { debug: debug, force_cause: force_cause } }
      subject(:formatter) { described_class.new(options) }

      describe '#debug?' do
        it 'returns false' do
          expect(formatter.debug?).to be false
        end

        context 'when debug is enabled' do
          let(:debug) { true }

          it 'returns true' do
            expect(formatter.debug?).to be true
          end
        end
      end

      describe '#format' do
        let(:message)   { 'some exception' }
        let(:exception) { Exception.new(message) }

        before { exception.set_backtrace %w[back trace] }

        it 'formats the message' do
          expect(formatter.format exception)
            .to match /^Exception: some exception$/
        end

        it 'indents the backtrace' do
          expect(formatter.format exception).to match /^\s+back$/
        end

        context 'filtering' do
          before { exception.set_backtrace %w[back trace /producer-core/lib/] }

          it 'excludes producer code from the backtrace' do
            expect(formatter.format exception).not_to include 'producer-core'
          end
        end
      end
    end
  end
end
