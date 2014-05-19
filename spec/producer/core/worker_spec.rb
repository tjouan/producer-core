require 'spec_helper'

module Producer::Core
  describe Worker do
    let(:env)         { Env.new }
    subject(:worker)  { described_class.new(env) }

    describe '#process' do
      it 'processes each task' do
        expect(worker).to receive(:process_task).with(:some_task)
        worker.process [:some_task]
      end
    end

    describe '#process_task' do
      let(:action)  { double 'action' }
      let(:task)    { double('task', actions: [action]).as_null_object }

      context 'when task condition is met' do
        it 'applies the actions' do
          expect(action).to receive :apply
          worker.process_task task
        end
      end

      context 'when task condition is not met' do
        before { allow(task).to receive(:condition_met?) { false } }

        it 'does not apply the actions' do
          expect(action).not_to receive :apply
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
