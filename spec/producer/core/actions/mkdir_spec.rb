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
    end
  end
end
