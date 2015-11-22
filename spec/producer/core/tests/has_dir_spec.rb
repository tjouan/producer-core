module Producer::Core
  module Tests
    RSpec.describe HasDir, :env do
      let(:path)        { 'some_directory' }
      subject(:has_dir) { described_class.new(env, path) }

      it_behaves_like 'test'

      describe '#verify' do
        it 'delegates the call on remote FS' do
          expect(remote_fs).to receive(:dir?).with(path)
          has_dir.verify
        end

        it 'returns the dir existence' do
          existence = double 'existence'
          allow(remote_fs).to receive(:dir?) { existence }
          expect(has_dir.verify).to be existence
        end
      end
    end
  end
end
