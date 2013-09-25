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
      end
    end
  end
end
