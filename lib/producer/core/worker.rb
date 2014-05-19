module Producer
  module Core
    class Worker
      attr_accessor :env

      def initialize(env)
        @env = env
      end

      def process(tasks)
        tasks.each { |t| process_task t }
      end

      def process_task(task)
        task.actions.each(&:apply) if task.condition_met?
      end
    end
  end
end
