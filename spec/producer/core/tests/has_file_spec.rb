require 'spec_helper'

module Producer::Core
  module Tests
    describe HasFile do
      let(:env)           { Env.new }
      let(:filepath)      { 'some_file' }
      subject(:has_file)  { HasFile.new(env, filepath) }

      it 'is a kind of test' do
        expect(has_file).to be_a Test
      end

      describe '#verify', :ssh do
        before { sftp_story }

        it 'delegates the call on remote FS' do
          expect(env.remote.fs).to receive(:file?).with(filepath)
          has_file.verify
        end

        it 'returns the file existence' do
          existence = double 'existence'
          allow(env.remote.fs).to receive(:file?) { existence }
          expect(has_file.verify).to be existence
        end
      end
    end
  end
end
