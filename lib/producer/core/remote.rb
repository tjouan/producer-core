module Producer
  module Core
    class Remote
      attr_reader :hostname
      attr_writer :session

      def initialize(hostname)
        @hostname = hostname
      end

      def session
        @session ||= Net::SSH.start(@hostname, user_name)
      end

      def config
        @config ||= Net::SSH::Config.for(@hostname)
      end

      def user_name
        config[:user] || Etc.getlogin
      end

      def fs
        @fs ||= Remote::FS.new(session.sftp.connect)
      end

      def execute(command, output = '', error_output = '')
        channel = session.open_channel do |channel|
          channel.exec command do |ch, success|
            ch.on_data do |c, data|
              output << data
            end

            ch.on_extended_data do |c, type, data|
              error_output << data
            end

            ch.on_request 'exit-status' do |c, data|
              exit_status = data.read_long
              fail RemoteCommandExecutionError, command if exit_status != 0
            end
          end
        end
        channel.wait
        output
      end

      def environment
        Environment.string_to_hash(execute 'env')
      end

      def cleanup
        session.close if @session
      end
    end
  end
end
