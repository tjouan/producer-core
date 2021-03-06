module Producer
  module Core
    class ErrorFormatter
      FILTERS = [
        /\/producer/,
        Regexp.new(RbConfig::CONFIG['rubylibdir']),
        /\/net-ssh/,
        /\/net-sftp/
      ].freeze

      def initialize debug: false
        @debug = debug
      end

      def debug?
        !!@debug
      end

      def format exception
        if debug? && exception.cause
          lines = format_exception exception, filter: true
          lines << ''
          lines << 'cause:'
          lines << format_exception(exception.cause, filter: false)
        else
          lines = format_exception exception, filter: !debug?
        end

        lines.join "\n"
      end

    private

      def format_exception exception, filter: true
        [
          format_message(exception),
          *format_backtrace(exception.backtrace, filter: filter)
        ]
      end

      def format_message exception
        "#{exception.class.name.split('::').last}: #{exception.message}"
      end

      def format_backtrace backtrace, filter: true
        backtrace = filter_backtrace backtrace if filter
        indent_backtrace backtrace
      end

      def filter_backtrace backtrace
        backtrace.reject do |line|
          FILTERS.any? { |filter| line =~ filter }
        end
      end

      def indent_backtrace backtrace
        backtrace.map { |e| '  ' + e }
      end
    end
  end
end
