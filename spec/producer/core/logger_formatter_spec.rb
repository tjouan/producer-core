module Producer::Core
  RSpec.describe LoggerFormatter do
    describe '#call' do
      let(:severity)  { double 'severity' }
      let(:datetime)  { double 'datetime' }
      let(:progname)  { double 'progname' }
      let(:message)   { 'some message' }

      subject { described_class.new.call(severity, datetime, progname, message) }

      it 'returns the given message with a line separator' do
        expect(subject).to eq "#{message}\n"
      end

      context 'when severity is WARN' do
        let(:severity) { 'WARN' }

        it 'prefix the message with `Warning:\'' do
          expect(subject).to match /\AWarning: #{message}/
        end
      end
    end
  end
end
