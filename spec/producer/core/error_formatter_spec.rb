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
        let(:rubylibdir)  { RbConfig::CONFIG['rubylibdir'] }
        let(:bt)          { %W[backtrace /producer-core /net-ssh #{rubylibdir}] }
        let(:exception)   { RuntimeError.new('some exception').tap { |o| o.set_backtrace bt } }

        def exception_with_cause
          begin fail 'exception cause' rescue fail 'some exception' end
        rescue => e
          e.tap { |o| o.set_backtrace bt }
        end

        it 'formats the message' do
          expect(formatter.format exception)
            .to match /^RuntimeError: some exception$/
        end

        it 'indents the backtrace' do
          expect(formatter.format exception).to match /^\s+backtrace$/
        end

        it 'excludes producer code from the backtrace' do
          expect(formatter.format exception).not_to include 'producer-core'
        end

        it 'excludes net-ssh from the backtrace' do
          expect(formatter.format exception).not_to include 'net-ssh'
        end

        it 'excludes ruby lib directory from the backtrace' do
          expect(formatter.format exception).not_to include rubylibdir
        end

        context 'when exception has a cause' do
          it 'does not include the cause' do
            expect(formatter.format exception_with_cause)
              .not_to include 'exception cause'
          end
        end

        context 'when debug is enabled' do
          let(:debug) { true }

          it 'does not filter the backtrace' do
            expect(formatter.format exception).to include 'producer-core'
          end

          context 'when exception has a cause' do
            it 'includes the exception cause' do
              expect(formatter.format exception_with_cause)
                .to include 'exception cause'
            end

            it 'formats the cause' do
              expect(formatter.format exception_with_cause)
                .to match /^cause:\nRuntimeError: exception cause/
            end
          end
        end
      end
    end
  end
end
