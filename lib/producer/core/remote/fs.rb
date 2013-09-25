module Producer
  module Core
    class Remote
      class FS
        require 'net/sftp'

        def initialize(remote)
          @remote = remote
        end

        def sftp
          @sftp ||= @remote.session.sftp.connect
        end

        def has_file?(path)
          sftp.stat!(path).file?
        rescue Net::SFTP::StatusException
          false
        end
      end
    end
  end
end
