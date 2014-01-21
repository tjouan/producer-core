module Producer
  module Core
    class Remote
      class FS
        require 'net/sftp'

        attr_reader :remote

        def initialize(remote)
          @remote = remote
        end

        def sftp
          @sftp ||= @remote.session.sftp.connect
        end

        def dir?(path)
          sftp.stat!(path).directory?
        rescue Net::SFTP::StatusException
          false
        end

        def file?(path)
          sftp.stat!(path).file?
        rescue Net::SFTP::StatusException
          false
        end

        def file_write(path, content)
          sftp.file.open path, 'w' do |f|
            f.write content
          end
        end
      end
    end
  end
end
