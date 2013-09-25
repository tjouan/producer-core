module Producer
  module Core
    class Remote
      class FS
        require 'net/sftp'

        def initialize(remote)
          @remote = remote
        end
      end
    end
  end
end
