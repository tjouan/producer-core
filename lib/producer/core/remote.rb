module Producer
  module Core
    class Remote
      require 'etc'
      require 'net/ssh'

      attr_accessor :hostname

      def initialize(hostname)
        @hostname = hostname
      end

      def session
        @session ||= Net::SSH.start(@hostname, Etc.getlogin)
      end

      def execute(command)
        output = ''
        session.exec command do |ch, stream, data|
          output << data
        end
        session.loop
        output
      end
    end
  end
end
