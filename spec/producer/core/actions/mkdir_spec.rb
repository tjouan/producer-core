require 'spec_helper'

module Producer::Core
  module Actions
    describe Mkdir, :env do
      let(:path)      { 'some_path' }
      let(:options)   { { } }
      let(:arguments) { [path] }
      subject(:mkdir) { described_class.new(env, *arguments, options) }

      it_behaves_like 'action'

      describe '#setup' do
        let(:options) { { mode: 0700, user: 'root' } }

        it 'translates mode option as permissions' do
          expect(mkdir.options[:permissions]).to eq 0700
        end

        it 'translates user option as owner' do
          expect(mkdir.options[:owner]).to eq 'root'
        end

        context 'when path is missing' do
          let(:path) { nil }

          it 'raises ArgumentError' do
            expect { mkdir }.to raise_error ArgumentError
          end
        end
      end

      describe '#apply' do
        before { allow(remote_fs).to receive(:dir?) { false } }

        it 'creates directory on remote filesystem' do
          expect(remote_fs).to receive(:mkdir).with(path)
          mkdir.apply
        end

        context 'when status options are given' do
          let(:options) { { group: 'wheel' } }

          it 'changes the directory status with given options' do
            expect(remote_fs).to receive(:setstat).with(path, options)
            mkdir.apply
          end
        end

        context 'when parent directories does not exists' do
          let(:path) { 'some/path' }

          it 'creates parent directories' do
            expect(remote_fs).to receive(:mkdir).with('some').ordered
            expect(remote_fs).to receive(:mkdir).with('some/path').ordered
            mkdir.apply
          end
        end

        context 'when directory already exists' do
          before { allow(remote_fs).to receive(:dir?) { true } }

          it 'does not create any directory' do
            expect(remote_fs).not_to receive(:mkdir)
            mkdir.apply
          end
        end
      end
    end
  end
end
