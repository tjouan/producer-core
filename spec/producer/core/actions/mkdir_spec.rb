require 'spec_helper'

module Producer::Core
  describe Actions::Mkdir do
    let(:env)       { Env.new }
    let(:path)      { 'some_path' }
    subject(:mkdir) { Actions::Mkdir.new(env, path) }

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
