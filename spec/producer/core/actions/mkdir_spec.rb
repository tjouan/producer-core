require 'spec_helper'

module Producer::Core
  module Actions
    describe Mkdir do
      let(:env)       { Env.new }
      let(:path)      { 'some_path' }
      subject(:mkdir) { Mkdir.new(env, path) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'creates directory on remote filesystem' do
          expect(mkdir.fs).to receive(:mkdir).with(path)
          mkdir.apply
        end
      end

      describe '#path' do
        it 'returns the path' do
          expect(mkdir.path).to eq path
        end
      end
    end
  end
end
