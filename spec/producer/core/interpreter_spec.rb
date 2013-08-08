require 'spec_helper'

module Producer::Core
  describe Interpreter do
    subject(:interpreter) { Interpreter.new }

    describe '#process' do
      it 'processes each task' do
        expect(interpreter).to receive(:process_task).with(:some_task)
        interpreter.process [:some_task]
      end
    end

    describe '#process_task' do
      let(:action)  { double('action') }
      let(:task)    { double('task').as_null_object }

      before do
        allow(task).to receive(:actions) { [action] }
      end

      context 'when task condition is met' do
        it 'applies the actions' do
          expect(action).to receive(:apply)
          interpreter.process_task(task)
        end
      end

      context 'when task condition is not met' do
        before do
          allow(task).to receive(:condition_met?) { false }
        end

        it 'does not apply the actions' do
          expect(action).not_to receive(:apply)
          interpreter.process_task(task)
        end
      end
    end
  end
end
