module Producer
  module Core
    class Worker
      DRY_RUN_WARNING =
        'running in dry run mode, actions will NOT be applied'.freeze

      attr_accessor :env

      def initialize(env)
        @env = env
      end

      def process(tasks)
        env.log DRY_RUN_WARNING, :warn if env.dry_run?

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
