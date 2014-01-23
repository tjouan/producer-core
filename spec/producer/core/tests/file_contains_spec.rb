require 'spec_helper'

module Producer::Core
  describe Tests::FileContains do
    let(:env)       { Env.new }
    let(:filepath)  { 'some_file' }
    let(:content)   { 'some_content' }
    subject(:test)  { Tests::FileContains.new(env, filepath, content) }

    it 'is a kind of test' do
      expect(test).to be_a Test
    end

    describe '#verify' do
      let(:fs) { double 'fs' }

      before { allow(test).to receive(:fs) { fs } }

      context 'when file contains the content' do
        before { allow(fs).to receive(:file_read).with(filepath) { "foo#{content}bar" } }

        it 'returns true' do
          expect(test.verify).to be true
        end
      end

      context 'when file does not contain the content' do
        before { allow(fs).to receive(:file_read).with(filepath) { 'foo bar' } }

        it 'returns false' do
          expect(test.verify).to be false
        end
      end

      context 'when file does not exist' do
        before { allow(fs).to receive(:file_read).with(filepath) { nil } }

        it 'returns false' do
          expect(test.verify).to be false
        end
      end
    end
  end
end
