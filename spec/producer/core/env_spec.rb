module Producer::Core
  describe Env do
    let(:output)  { StringIO.new }
    subject(:env) { described_class.new(output: output) }

    describe '#initialize' do
      it 'assigns $stdin as the default input' do
        expect(env.input).to be $stdin
      end

      it 'assigns $stderr as the default error output' do
        expect(env.error_output).to be $stderr
      end

      it 'assigns no default target' do
        expect(env.target).not_to be
      end

      it 'assigns an empty registry' do
        expect(env.registry).to be_empty
      end

      it 'assigns verbose as false' do
        expect(env.verbose).to be false
      end

      it 'assigns debug as false' do
        expect(env.debug).to be false
      end

      it 'assigns dry run as false' do
        expect(env.dry_run).to be false
      end

      context 'when output is not given as argument' do
        subject(:env) { described_class.new }

        it 'assigns $stdout as the default output' do
          expect(env.output).to be $stdout
        end
      end

      context 'when input is given as argument' do
        let(:input)   { double 'input' }
        subject(:env) { described_class.new(input: input) }

        it 'assigns the given input' do
          expect(env.input).to be input
        end
      end

      context 'when output is given as argument' do
        subject(:env) { described_class.new(output: output) }

        it 'assigns the given output' do
          expect(env.output).to be output
        end
      end

      context 'when error output is given as argument' do
        let(:error_output)  { StringIO.new }
        subject(:env)       { described_class.new(error_output: error_output) }

        it 'assigns the given error output' do
          expect(env.error_output).to be error_output
        end
      end

      context 'when remote is given as argument' do
        let(:remote)  { double 'remote' }
        subject(:env) { described_class.new(remote: remote) }

        it 'assigns the given remote' do
          expect(env.remote).to be remote
        end
      end
    end

    describe '#target' do
      let(:target) { double 'target' }

      it 'returns the assigned target' do
        env.target = target
        expect(env.target).to be target
      end
    end

    describe '#remote' do
      it 'builds a Remote with the current target' do
        env.target = 'some_hostname.example'
        expect(Remote).to receive(:new).with(env.target)
        env.remote
      end

      it 'returns the remote' do
        remote = double 'remote'
        allow(Remote).to receive(:new) { remote }
        expect(env.remote).to eq remote
      end

      it 'memoizes the remote' do
        expect(env.remote).to be env.remote
      end
    end

    describe '#[]' do
      subject(:env) { Env.new(registry: { some_key: :some_value }) }

      it 'returns the value indexed by given key from the registry' do
        expect(env[:some_key]).to eq :some_value
      end

      it 'raises an error when given invalid key' do
        expect { env[:no_key] }.to raise_error RegistryKeyError
      end
    end

    describe '#[]=' do
      it 'registers given value at given index in the registry' do
        env[:some_key] = :some_value
        expect(env[:some_key]).to eq :some_value
      end
    end

    describe '#logger' do
      it 'returns a logger' do
        expect(env.logger).to be_a Logger
      end

      it 'uses env output' do
        env.logger.error 'some message'
        expect(output.string).to include 'some message'
      end

      it 'has a log level of WARN' do
        expect(env.logger.level).to eq Logger::WARN
      end

      it 'uses our formatter' do
        expect(env.logger.formatter).to be_a LoggerFormatter
      end

      context 'when verbose mode is enabled' do
        before { env.verbose = true }

        it 'has a log level of INFO' do
          expect(env.logger.level).to eq Logger::INFO
        end
      end
    end

    describe '#log' do
      it 'logs an info message through the assigned logger' do
        expect(env.logger).to receive(:info).with 'message'
        env.log 'message'
      end

      context 'when second argument is :warn' do
        it 'logs a warning message through the assigned logger' do
          expect(env.logger).to receive(:warn).with 'message'
          env.log 'message', :warn
        end
      end
    end

    describe '#verbose?' do
      it 'returns true when verbose is enabled' do
        env.verbose = true
        expect(env).to be_verbose
      end
    end

    describe '#debug?' do
      it 'returns true when debug is enabled' do
        env.debug = true
        expect(env).to be_debug
      end
    end

    describe '#dry_run?' do
      it 'returns true when dry run is enabled' do
        env.dry_run = true
        expect(env).to be_dry_run
      end
    end

    describe '#cleanup' do
      it 'cleans up the remote' do
        expect(env.remote).to receive :cleanup
        env.cleanup
      end
    end
  end
end
