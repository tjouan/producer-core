require 'spec_helper'

module Producer::Core
  module Actions
    describe Echo do
      let(:env)       { Env.new(output: StringIO.new) }
      let(:text)      { 'hello' }
      subject(:echo)  { Echo.new(env, text) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'writes the given string to env output with a record separator' do
          echo.apply
          expect(env.output.string).to eq "hello\n"
        end
      end
    end
  end
end
