require 'spec_helper'

module Producer::Core
  module Tests
    describe HasDir do
      let(:env)         { Env.new }
      let(:path)        { 'some_directory' }
      subject(:has_dir) { HasDir.new(env, path) }

      it_behaves_like 'test'

      describe '#verify', :ssh do
        before { sftp_story }

        it 'delegates the call on remote FS' do
          expect(env.remote.fs).to receive(:dir?).with(path)
          has_dir.verify
        end

        it 'returns the dir existence' do
          existence = double 'existence'
          allow(env.remote.fs).to receive(:dir?) { existence }
          expect(has_dir.verify).to be existence
        end
      end
    end
  end
end
