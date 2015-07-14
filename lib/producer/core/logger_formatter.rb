module Producer
  module Core
    class LoggerFormatter < Logger::Formatter
      def call severity, _datetime, _progname, message
        prefix(severity) + message + "\n"
      end

    private

      def prefix severity
        severity == 'WARN' ? 'Warning: ' : ''
      end
    end
  end
end
