module Producer
  module Core
    module Actions
      class FileAppend < Action
        def name
          'file_append'
        end

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
          original_content = fs.file_read(path)

          return content unless original_content
          original_content + content
        end
      end
    end
  end
end
