require 'spec_helper'

module Producer::Core
  module Actions
    describe Echo, :env do
      let(:text)      { 'hello' }
      subject(:echo)  { described_class.new(env, text) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'writes the given string to env output with a record separator' do
          echo.apply
          expect(output).to eq "hello\n"
        end
      end
    end
  end
end
