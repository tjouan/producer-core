module Producer
  module Core
    class ErrorFormatter
      def initialize(debug: false, force_cause: [])
        @debug        = debug
        @force_cause  = force_cause
      end

      def debug?
        !!@debug
      end

      def format(exception)
        lines = format_exception exception

        if debug? && exception.cause
          lines << ''
          lines << 'cause:'
          lines << format_exception(exception.cause, filter: false)
        end

        lines.join("\n")
      end


      private

      def format_exception(exception, filter: true)
        [
          format_message(exception),
          *format_backtrace(exception.backtrace, filter: filter)
        ]
      end

      def format_message(exception)
        exception = exception.cause if @force_cause.include? exception.class
        "#{exception.class.name.split('::').last}: #{exception.message}"
      end

      def format_backtrace(backtrace, filter: true)
        backtrace = filter_backtrace backtrace if filter
        indent_backtrace backtrace
      end

      def filter_backtrace(backtrace)
        backtrace.reject { |l| l =~ /\/producer-\w+\/(?:bin|lib)\// }
      end

      def indent_backtrace(backtrace)
        backtrace.map { |e| '  %s' % e }
      end
    end
  end
end