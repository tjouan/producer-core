require 'spec_helper'

module Producer::Core
  describe Tests::HasFile do
    let(:env)           { Env.new }
    let(:filepath)      { 'some_file' }
    subject(:has_file)  { Tests::HasFile.new(env, filepath) }

    it 'is a kind of test' do
      expect(has_file).to be_a Test
    end

    describe '#success?', :ssh do
      before { sftp_story }

      it 'delegates the call on remote FS' do
        expect(env.remote.fs).to receive(:has_file?).with(filepath)
        has_file.success?
      end

      it 'returns the file existence' do
        existence = double('existence')
        allow(env.remote.fs).to receive(:has_file?) { existence }
        expect(has_file.success?).to be existence
      end
    end
  end
end
