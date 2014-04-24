require 'spec_helper'

module Producer::Core
  module Tests
    describe HasEnv do
      let(:env)           { Env.new }
      let(:variable_name) { 'SOME_VAR' }
      let(:remote_env)    { { 'SOME_VAR' => 'SOME_VALUE' } }
      subject(:has_env)   { HasEnv.new(env, variable_name) }

      it_behaves_like 'test'

      before do
        allow(env.remote).to receive(:environment) { remote_env }
      end

      describe '#verify' do
        context 'remote environment var is defined' do
          it 'returns true' do
            expect(has_env.verify).to be true
          end

          context 'when var name is given as a lowercase symbol' do
            let(:variable_name) { :some_var }

            it 'returns true' do
              expect(has_env.verify).to be true
            end
          end
        end

        context 'remote environment var is not defined' do
          let(:variable_name) { 'SOME_NON_EXISTENT_VAR' }

          it 'returns false' do
            expect(has_env.verify).to be false
          end
        end
      end
    end
  end
end
