require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:block)     { Proc.new { } }
    subject(:task)  { Task.new(name, &block) }

    describe '#name' do
      it 'returns its name' do
        expect(task.name).to eq name
      end
    end

    describe '#evaluate' do
      it 'builds a task DSL sandbox' do
        expect(Task::DSL).to receive(:new).with(&block)
        task.evaluate
      end
    end
  end
end
