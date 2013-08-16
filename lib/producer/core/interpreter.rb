module Producer
  module Core
    class Interpreter
      def process(tasks)
        tasks.each { |t| process_task t }
      end

      def process_task(task)
        task.actions.each(&:apply)
      end
    end
  end
end
