require 'spec_helper'

module Producer::Core
  describe Actions::Echo do
    let(:env)       { Env.new }
    let(:text)      { 'hello' }
    subject(:echo)  { Actions::Echo.new(env, text) }

    describe '#apply' do
      before do
        env.output = StringIO.new
      end

      it 'outputs the string given as argument through env.output' do
        expect(env).to receive(:output).with(text)
        echo.apply
      end
    end
  end
end
