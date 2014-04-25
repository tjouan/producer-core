require 'spec_helper'

module Producer::Core
  module Actions
    describe Mkdir, :env do
      let(:path)      { 'some_path' }
      subject(:mkdir) { Mkdir.new(env, path) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'creates directory on remote filesystem' do
          expect(remote_fs).to receive(:mkdir).with(path)
          mkdir.apply
        end

        context 'when a mode was given' do
          subject(:mkdir) { Mkdir.new(env, path, 0700) }

          it 'creates the directory with given mode' do
            expect(remote_fs).to receive(:mkdir).with(anything, 0700)
            mkdir.apply
          end
        end
      end

      describe '#path' do
        it 'returns the path' do
          expect(mkdir.path).to eq path
        end
      end

      describe '#mode' do
        it 'returns nil' do
          expect(mkdir.mode).to be nil
        end

        context 'when a mode was given' do
          subject(:mkdir) { Mkdir.new(env, path, 0700) }

          it 'returns the mode' do
            expect(mkdir.mode).to be 0700
          end
        end
      end
    end
  end
end
