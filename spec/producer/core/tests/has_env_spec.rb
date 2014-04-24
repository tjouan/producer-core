require 'spec_helper'

module Producer::Core
  module Tests
    describe HasEnv do
      let(:env)         { Env.new }
      let(:var_name)    { 'SOME_VAR' }
      let(:var_value)   { 'SOME_VALUE' }
      let(:remote_env)  { { 'SOME_VAR' => 'SOME_VALUE' } }
      subject(:has_env) { HasEnv.new(env, var_name) }

      it_behaves_like 'test'

      before do
        allow(env.remote).to receive(:environment) { remote_env }
      end

      context 'when only var name is provided' do
        describe '#verify' do
          context 'when remote environment var is defined' do
            it 'returns true' do
              expect(has_env.verify).to be true
            end

            context 'when var name is given as a lowercase symbol' do
              let(:var_name) { :some_var }

              it 'returns true' do
                expect(has_env.verify).to be true
              end
            end
          end

          context 'when remote environment var is not defined' do
            let(:var_name) { 'SOME_NON_EXISTENT_VAR' }

            it 'returns false' do
              expect(has_env.verify).to be false
            end
          end
        end
      end

      context 'when var name and value are provided' do
        subject(:has_env) { HasEnv.new(env, var_name, var_value) }

        describe '#verify' do
          context 'when remote environment var is defined' do
            context 'when value is the same' do
              it 'returns true' do
                expect(has_env.verify).to be true
              end
            end

            context 'when value differs' do
              let(:remote_env) { { 'SOME_VAR' => 'SOME_OTHER_VALUE' } }

              it 'return false' do
                expect(has_env.verify).to be false
              end
            end
          end

          context 'when remote environment var is not defined' do
            let(:var_name) { 'SOME_NON_EXISTENT_VAR' }

            it 'return false' do
              expect(has_env.verify).to be false
            end
          end
        end
      end
    end
  end
end
