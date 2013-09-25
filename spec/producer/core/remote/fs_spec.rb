require 'spec_helper'

module Producer::Core
  describe Remote::FS do
    let(:remote)  { Remote.new('some_host.example') }
    subject(:fs)  { Remote::FS.new(remote) }

    describe '#new' do
      it 'assigns the remote given as argument' do
        expect(fs.instance_eval { @remote }).to be remote
      end
    end
  end
end
