module Producer
  module Core
    class LoggerFormatter < Logger::Formatter
      def call(severity, datetime, progname, message)
        message + "\n"
      end
    end
  end
end
