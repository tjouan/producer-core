require 'spec_helper'

module Producer::Core
  describe Remote do
    let(:hostname)    { 'some_host.example' }
    subject(:remote)  { Remote.new(hostname) }

    describe '#hostname' do
      it 'returns the assignated hostname' do
        expect(remote.hostname).to be hostname
      end
    end

    describe '#session' do
      it 'builds a new SSH session to the remote host' do
        expect(Net::SSH).to receive(:start).with(hostname, Etc.getlogin)
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

    describe '#fs' do
      it 'builds a new FS' do
        expect(Remote::FS).to receive(:new)
        remote.fs
      end

      it 'returns the new FS instance' do
        fs = double('fs')
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
        remote.execute command
        expect(story_completed?).to be
      end

      it 'returns the output' do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data arguments
        end
        expect(remote.execute(command)).to eq arguments
      end

      it 'raises an exception when the exit status code is not 0' do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data arguments
          ch.gets_exit_status 1
        end
        expect { remote.execute(command) }
          .to raise_error(RemoteCommandExecutionError)
      end
    end

    describe '#environment', :ssh do
      let(:command) { 'env' }
      let(:output)  { "FOO=bar\nBAZ=qux" }

      before do
        story_with_new_channel do |ch|
          ch.sends_exec command
          ch.gets_data output
        end
      end

      it 'builds a remote environment with the result of `env` command' do
        expect(Remote::Environment).to receive(:new).with(output)
        remote.environment
      end

      it 'returns the environment' do
        environment = double('environment')
        allow(Remote::Environment).to receive(:new) { environment }
        expect(remote.environment).to be environment
      end
    end
  end
end
