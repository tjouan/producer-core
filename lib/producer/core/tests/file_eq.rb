module Producer
  module Core
    module Tests
      class FileEq < Test
        def verify
          file_content ? file_content == expected_content : false
        end


        private

        def file_content
          @file_content ||= fs.file_read(arguments[0])
        end

        def expected_content
          arguments[1]
        end
      end
    end
  end
end
