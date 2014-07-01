module Producer
  module Core
    class LoggerFormatter < Logger::Formatter
      def call(severity, datetime, progname, message)
        prefix(severity) + message + "\n"
      end


      private

      def prefix(severity)
        severity == 'WARN' ? 'Warning: ' : ''
      end
    end
  end
end
