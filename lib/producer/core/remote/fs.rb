module Producer
  module Core
    class Remote
      class FS
        attr_reader :sftp

        def initialize sftp
          @sftp = sftp
        end

        def dir? path
          sftp.stat!(path).directory?
        rescue Net::SFTP::StatusException
          false
        end

        def file? path
          sftp.stat!(path).file?
        rescue Net::SFTP::StatusException
          false
        end

        def setstat path, attributes
          sftp.setstat! path, attributes
        end

        def chmod path, mode
          setstat path, permissions: mode
        end

        def mkdir path, attributes = {}
          sftp.mkdir! path, attributes
        end

        def file_read path
          sftp.file.open path, &:read
        rescue Net::SFTP::StatusException
          nil
        end

        def file_write path, content
          sftp.file.open path, 'w' do |f|
            f.write content
          end
        end
      end
    end
  end
end
