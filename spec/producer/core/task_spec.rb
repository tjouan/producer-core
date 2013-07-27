require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:block)     { }
    subject(:task)  { Task.new(name, &block) }

    describe '#name' do
      it 'returns its name' do
        expect(task.name).to eq name
      end
    end

    describe 'evaluate' do
      let(:block) { Proc.new { raise 'error from task' } }

      it 'evaluates its block' do
        expect { task.evaluate }.to raise_error(RuntimeError, 'error from task')
      end
    end
  end
end
