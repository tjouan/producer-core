module Producer
  module Core
    class Worker
      DRY_RUN_WARNING =
        'running in dry run mode, actions will NOT be applied'.freeze

      def initialize env
        @env = env
      end

      def process tasks
        @env.log DRY_RUN_WARNING, :warn if @env.dry_run?

        tasks.each { |t| process_task t }
      end

      def process_task task, indent_level = 0
        if task.condition_met?
          log "Task: `#{task}' applying...", indent_level
          task.actions.each do |e|
            case e
            when Task then process_task e, indent_level + 2
            else
              log " action: #{e}", indent_level
              e.apply unless @env.dry_run?
            end
          end
        else
          log "Task: `#{task}' skipped", indent_level
        end
      end

    private

      def log message, indent_level
        message = [' ' * indent_level, message].join
        @env.log message
      end
    end
  end
end
