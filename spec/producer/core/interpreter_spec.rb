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
      it 'applies the task actions' do
        action = double('action')
        task = double('task')
        allow(task).to receive(:actions) { [action] }
        expect(action).to receive(:apply)
        interpreter.process_task(task)
      end
    end
  end
end
