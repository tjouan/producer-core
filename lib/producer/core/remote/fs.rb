module Producer
  module Core
    class Remote
      class FS
        attr_reader :sftp

        def initialize(sftp)
          @sftp = sftp
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

        def mkdir(path, mode = nil)
          options = mode ? { permissions: mode } : {}
          sftp.mkdir! path, options
        end

        def file_read(path)
          sftp.file.open(path) { |f| content = f.read }
        rescue Net::SFTP::StatusException
          nil
        end

        def file_write(path, content, mode = nil)
          sftp.file.open path, 'w', mode do |f|
            f.write content
          end
        end
      end
    end
  end
end
