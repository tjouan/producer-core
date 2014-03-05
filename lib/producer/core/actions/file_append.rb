module Producer
  module Core
    module Actions
      class FileAppend < Action
        def apply
          fs.file_write path, combined_content
        end

        def path
          arguments[0]
        end

        def content
          arguments[1]
        end

        def combined_content
          fs.file_read(path) + content
        end
      end
    end
  end
end