require 'spec_helper'

module Producer::Core
  describe Worker do
    subject(:worker) { Worker.new }

    describe '#process' do
      it 'processes each task' do
        expect(worker).to receive(:process_task).with(:some_task)
        worker.process [:some_task]
      end
    end

    describe '#process_task' do
      it 'applies the task actions' do
        action = double('action')
        task = double('task')
        allow(task).to receive(:actions) { [action] }
        expect(action).to receive(:apply)
        worker.process_task(task)
      end
    end
  end
end
