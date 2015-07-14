module Producer
  module Core
    module Tests
      class FileMatch < Test
        def verify
          !!(file_content =~ arguments[1])
        end

      private

        def file_content
          fs.file_read(arguments[0]) or ''
        end
      end
    end
  end
end
