module Producer
  module Core
    module Tests
      class FileContains < Test
        def verify
          content = file_content
          content ? content.include?(arguments[1]) : false
        end


        private

        def file_content
          fs.file_read(arguments[0])
        end
      end
    end
  end
end
