require 'spec_helper'

module Producer::Core
  describe Worker do
    let(:env)         { double 'env', log: nil, dry_run?: false }
    subject(:worker)  { described_class.new(env) }

    describe '#process' do
      it 'processes each task' do
        expect(worker).to receive(:process_task).with(:some_task)
        worker.process [:some_task]
      end

      context 'when dry run is enabled' do
        before { allow(env).to receive(:dry_run?) { true } }

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
      let(:action)    { double('action', to_s: 'echo').as_null_object }
      let(:task_name) { 'some_task' }
      let(:task)      { Task.new(task_name, [action]) }

      it 'logs task info' do
        expect(env).to receive(:log).with /\ATask: `#{task_name}'/
        worker.process_task task
      end

      context 'when task condition is met' do
        it 'applies the actions' do
          expect(action).to receive :apply
          worker.process_task task
        end

        it 'logs the task as beeing applied' do
          expect(env).to receive(:log).with /#{task_name}.+applying\.\.\.\z/
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
        let(:task) { Task.new(task_name, [action], false) }

        it 'does not apply the actions' do
          expect(action).not_to receive :apply
          worker.process_task task
        end

        it 'logs the task as beeing skipped' do
          expect(env).to receive(:log).with /#{task_name}.+skipped\z/
          worker.process_task task
        end
      end
    end

    describe '#env' do
      it 'returns the assigned env' do
        expect(worker.env).to be env
      end
    end
  end
end
