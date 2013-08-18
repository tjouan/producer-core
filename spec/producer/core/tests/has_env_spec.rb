require 'spec_helper'

module Producer::Core
  describe Tests::HasEnv do
    let(:env)           { Env.new }
    let(:variable_name) { :some_variable_name }
    subject(:has_env)   { Tests::HasEnv.new(env, variable_name) }

    it 'is a kind of test' do
      expect(has_env).to be_a Test
    end

    describe '#success?' do
      let(:environment) { double('environment') }

      before do
        allow(env.remote).to receive(:environment) { environment }
      end

      it 'stringifies the queried variable name' do
        expect(environment).to receive(:has_key?).with(kind_of(String))
        has_env.success?
      end

      it 'upcases the queried variable name' do
        expect(environment).to receive(:has_key?).with('SOME_VARIABLE_NAME')
        has_env.success?
      end

      it 'returns true when remote environment var is defined' do
        allow(environment).to receive(:has_key?) { true }
        expect(has_env.success?).to be true
      end

      it 'returns false when remote environment var is not defined' do
        allow(environment).to receive(:has_key?) { false }
        expect(has_env.success?).to be false
      end
    end
  end
end
