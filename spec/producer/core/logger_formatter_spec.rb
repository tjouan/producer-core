require 'spec_helper'

module Producer::Core
  describe LoggerFormatter do
    describe '#call' do
      let(:severity)  { double 'severity' }
      let(:datetime)  { double 'datetime' }
      let(:progname)  { double 'progname' }
      let(:message)   { 'some message' }

      subject { described_class.new.call(severity, datetime, progname, message) }

      it 'returns the given message with a line separator' do
        expect(subject).to eq "#{message}\n"
      end
    end
  end
end
