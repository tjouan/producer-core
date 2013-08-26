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
        @session ||= Net::SSH.start(@hostname, user_name)
      end

      def user_name
        Etc.getlogin
      end

      def fs
        @fs ||= Remote::FS.new(self)
      end

      def execute(command)
        output = ''
        session.open_channel do |channel|
          channel.exec command do |ch, success|
            ch.on_data do |c, data|
              output << data
            end

            ch.on_request('exit-status') do |c, data|
              exit_status = data.read_long
              raise RemoteCommandExecutionError if exit_status != 0
            end
          end
        end
        session.loop
        output
      end

      def environment
        Environment.new(execute 'env')
      end
    end
  end
end
