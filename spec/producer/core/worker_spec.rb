module Producer::Core
  describe Worker do
    let(:env)         { Env.new }
    subject(:worker)  { described_class.new(env) }

    describe '#process' do
      it 'processes each task' do
        expect(worker).to receive(:process_task).with(:some_task)
        worker.process [:some_task]
      end

      context 'when dry run is enabled' do
        before { env.dry_run = true }

        it 'warns dry run is enabled' do
          expect(env).to receive(:log).with(
            /\Arunning in dry run mode, actions will NOT be applied\z/,
            :warn
          )
          worker.process []
        end
      end
    end

    describe '#process_task' do
      let(:env)     { instance_spy Env, dry_run?: false }
      let(:action)  { double('action', to_s: 'echo').as_null_object }
      let(:task)    { Task.new(env, :some_task, [action]) }

      it 'logs task info' do
        expect(env).to receive(:log).with /\ATask: `some_task'/
        worker.process_task task
      end

      context 'when task condition is met' do
        it 'applies the actions' do
          expect(action).to receive :apply
          worker.process_task task
        end

        it 'logs the task as beeing applied' do
          expect(env).to receive(:log).with /some_task.+applying\.\.\.\z/
          worker.process_task task
        end

        it 'logs action info' do
          expect(env).to receive(:log).with /\A action: echo/
          worker.process_task task
        end

        context 'when dry run is enabled' do
          before { allow(env).to receive(:dry_run?) { true } }

          it 'does not apply the actions' do
            expect(action).not_to receive :apply
            worker.process_task task
          end
        end
      end

      context 'when task condition is not met' do
        before { task.condition { false } }

        it 'does not apply the actions' do
          expect(action).not_to receive :apply
          worker.process_task task
        end

        it 'logs the task as being skipped' do
          expect(env).to receive(:log).with /some_task.+skipped\z/
          worker.process_task task
        end
      end

      context 'when a task contains nested tasks' do
        let(:inner_task)  { Task.new(env, :inner, [action]) }
        let(:outer_task)  { Task.new(env, :outer, [inner_task]) }

        it 'processes nested tasks' do
          expect(action).to receive :apply
          worker.process [outer_task]
        end
      end
    end
  end
end
