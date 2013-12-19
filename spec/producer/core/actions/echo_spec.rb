require 'spec_helper'

module Producer::Core
  describe Actions::Echo do
    let(:env)       { double 'env' }
    let(:text)      { 'hello' }
    subject(:echo)  { Actions::Echo.new(env, text) }

    describe '#apply' do
      it 'outputs the string given as argument through env.output' do
        expect(env).to receive(:output).with(text)
        echo.apply
      end
    end
  end
end
