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
    end
  end
end
