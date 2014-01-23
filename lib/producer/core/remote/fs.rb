module Producer
  module Core
    class Remote
      class FS
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

        def mkdir(path)
          sftp.mkdir! path
        end

        def file_read(path)
          sftp.file.open(path) { |f| content = f.read }
        rescue Net::SFTP::StatusException
          nil
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
