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
        if task.condition_met?
          env.log "Task: `#{task}' applying..."
          task.actions.each do |e|
            env.log " action: #{e} applying"
            e.apply unless env.dry_run?
          end
        else
          env.log "Task: `#{task}' skipped"
        end
      end
    end
  end
end
