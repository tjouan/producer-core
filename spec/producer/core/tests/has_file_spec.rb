require 'spec_helper'

module Producer::Core
  module Tests
    describe HasFile, :env do
      let(:filepath)      { 'some_file' }
      subject(:has_file)  { HasFile.new(env, filepath) }

      it_behaves_like 'test'

      describe '#verify' do
        it 'delegates the call on remote FS' do
          expect(remote_fs).to receive(:file?).with(filepath)
          has_file.verify
        end

        it 'returns the file existence' do
          existence = double 'existence'
          allow(remote_fs).to receive(:file?) { existence }
          expect(has_file.verify).to be existence
        end
      end
    end
  end
end
