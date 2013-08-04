require 'spec_helper'

module Producer::Core
  describe Remote do
    require 'net/ssh/test'
    include Net::SSH::Test

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

    describe '#execute' do
      let(:args)    { 'some remote command'}
      let(:command) { "echo #{args}" }

      # FIXME: refactor this with helpers, expectations and/or matchers.
      def with_new_channel_story
        story do |session|
          ch = session.opens_channel
          yield ch
          ch.gets_close
          ch.sends_close
        end
      end

      def story_completed?
        socket.script.events.empty?
      end

      before do
        allow(remote).to receive(:session) { connection }
      end

      it 'executes the given command in a new channel' do
        with_new_channel_story do |ch|
          ch.sends_exec command
          ch.gets_data args
        end
        remote.execute command
        expect(story_completed?).to be
      end

      it 'returns the output' do
        with_new_channel_story do |ch|
          ch.sends_exec command
          ch.gets_data args
        end
        expect(remote.execute(command)).to eq args
      end
    end
  end
end
