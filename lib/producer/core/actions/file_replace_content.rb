module Producer
  module Core
    module Actions
      class FileReplaceContent < Action
        def setup
          @path, @pattern, @replacement = arguments
        end

        def name
          'file_replace_content'
        end

        def apply
          fs.file_write @path, replaced_content
        end

        def replaced_content
          fs.file_read(@path).gsub @pattern, @replacement
        end
      end
    end
  end
end
