module Producer
  module Core
    class Remote
      attr_reader :hostname
      attr_writer :session

      def initialize hostname
        @hostname = hostname
      end

      def session
        @session ||= begin
          check_hostname!
          Net::SSH.start(@hostname, user_name)
        end
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

      def execute command, output = '', error_output = ''
        session.open_channel do |channel|
          channel.exec command do |ch, _success|
            ch.on_data do |_c, data|
              output << data
            end

            ch.on_extended_data do |_c, _type, data|
              error_output << data
            end

            ch.on_request 'exit-status' do |_c, data|
              exit_status = data.read_long
              fail RemoteCommandExecutionError, command if exit_status != 0
            end
          end
        end.wait
        output
      end

      def environment
        Environment.string_to_hash(execute 'env')
      end

      def cleanup
        session.close if @session
      end

    private

      def check_hostname!
        return if @hostname
        fail RemoteInvalidError,
          "remote target is invalid: `#{@hostname.inspect}'"
      end
    end
  end
end
