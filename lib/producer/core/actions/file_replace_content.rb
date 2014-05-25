module Producer
  module Core
    module Actions
      class FileReplaceContent < Action
        def name
          'file_replace_content'
        end

        def apply
          fs.file_write path, replaced_content
        end

        def path
          arguments[0]
        end

        def pattern
          arguments[1]
        end

        def replacement
          arguments[2]
        end

        def replaced_content
          fs.file_read(path).gsub pattern, replacement
        end
      end
    end
  end
end
