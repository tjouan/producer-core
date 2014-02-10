require 'spec_helper'

module Producer::Core
  module Tests
    describe FileContains do
      let(:env)       { Env.new }
      let(:filepath)  { 'some_file' }
      let(:content)   { 'some_content' }
      subject(:test)  { FileContains.new(env, filepath, content) }

      it_behaves_like 'test'

      describe '#verify' do
        let(:fs) { double 'fs' }

        before { allow(test).to receive(:fs) { fs } }

        context 'when file contains the content' do
          before do
            allow(fs)
              .to receive(:file_read).with(filepath) { "foo#{content}bar" }
          end

          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'when file does not contain the content' do
          before do
            allow(fs).to receive(:file_read).with(filepath) { 'foo bar' }
          end

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
end
