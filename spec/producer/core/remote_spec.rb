require 'spec_helper'

module Producer::Core
  describe Remote do
    let(:hostname)    { 'some_host.example' }
    subject(:remote)  { Remote.new(hostname) }

    describe '#initialize' do
      it 'assigns the given hostname' do
        expect(remote.hostname).to eq hostname
      end
    end

    describe '#session' do
      it 'builds a new SSH session to the remote host with #user_name' do
        expect(Net::SSH).to receive(:start).with(hostname, remote.user_name)
        remote.session
      end

      it 'returns the session' do
        session = double('SSH session')
        allow(Net::SSH).to receive(:start) { session }
        expect(remote.session).to eq session
      end

      it 'memoizes the session' do
        allow(Net::SSH).to receive(:start) { Object.new }
        expect(remote.session).to be remote.session
      end
    end

    describe '#config' do
      it 'builds a config for current host name' do
        expect(Net::SSH::Config).to receive(:for).with(hostname)
        remote.config
      end

      it 'returns the config' do
        ssh_config = double('ssh config')
        allow(Net::SSH::Config).to receive(:for) { ssh_config }
        expect(remote.config).to be ssh_config
      end

      it 'memoizes the config' do
        allow(Net::SSH::Config).to receive(:for) { Object.new }
        expect(remote.config).to be remote.config
      end
    end

    describe '#user_name' do
      context 'ssh config has an entry for user' do
        let(:config_user_name) { 'my_user_name' }

        before do
          allow(Net::SSH::Config).to receive(:for) { { user: config_user_name } }
        end

        it 'returns the configured value' do
          expect(remote.user_name).to eq config_user_name
        end
      end

      context 'ssh config has no entry for user' do
        it 'returns the name of the user currently logged in' do
          expect(remote.user_name).to eq Etc.getlogin
        end
      end
    end

    describe '#fs' do
      it 'builds a new FS' do
        expect(Remote::FS).to receive :new
        remote.fs
      end

      it 'returns the new FS instance' do
        fs = double 'fs'
        allow(Remote::FS).to receive(:new) { fs }
        expect(remote.fs).to be fs
      end

      it 'memoizes the FS' do
        allow(Remote::FS).to receive(:new) { Object.new }
        expect(remote.fs).to be remote.fs
      end
    end

    describe '#execute', :ssh do
      let(:arguments) { 'some remote command' }
      let(:command)   { "echo #{arguments}" }

      it 'executes the given command in a new channel' do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data arguments
        end
        expect_story_completed { remote.execute command }
      end

      it 'returns the output' do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data arguments
        end
        expect(remote.execute command).to eq arguments
      end

      it 'raises an exception when the exit status code is not 0' do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data arguments
          ch.gets_exit_status 1
        end
        expect { remote.execute command }
          .to raise_error(RemoteCommandExecutionError)
      end
    end

    describe '#environment' do
      let(:command) { 'env' }
      let(:output)  { 'FOO=bar' }

      before { allow(remote).to receive(:execute) { output } }

      it 'returns a remote environment' do
        expect(remote.environment['FOO']).to eq 'bar'
      end
    end
  end
end
