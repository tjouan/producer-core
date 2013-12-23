require 'spec_helper'

module Producer::Core
  describe Actions::Echo do
    let(:env)       { Env.new(output: StringIO.new) }
    let(:text)      { 'hello' }
    subject(:echo)  { Actions::Echo.new(env, text) }

    describe '#apply' do
      it 'writes the given string to env.output with a record separator' do
        echo.apply
        expect(env.output.string).to eq "hello\n"
      end
    end
  end
end
