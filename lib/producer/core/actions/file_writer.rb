module Producer
  module Core
    module Actions
      class FileWriter < Action
        def apply
          case arguments.size
          when 2
            fs.file_write path, content
          when 3
            fs.file_write path, content, mode
          end
        end

        def path
          arguments[0]
        end

        def content
          arguments[1]
        end

        def mode
          arguments[2]
        end
      end
    end
  end
end
