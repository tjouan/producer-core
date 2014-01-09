require 'spec_helper'

module Producer::Core
  describe Actions::FileWriter do
    let(:env)           { Env.new }
    let(:path)          { 'some_path' }
    let(:content)       { 'some_content' }
    subject(:writer)    { Actions::FileWriter.new(env, path, content) }

    describe '#apply' do
      it 'writes the content to remote file' do
        expect(writer.remote.fs).to receive(:file_write).with(path, content)
        writer.apply
      end
    end

    describe '#path' do
      it 'returns the path' do
        expect(writer.path).to eq path
      end
    end

    describe '#content' do
      it 'returns the content' do
        expect(writer.content).to eq content
      end
    end
  end
end
