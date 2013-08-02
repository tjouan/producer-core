module Producer
  module Core
    module Actions
      class FileWriter < Action
        def apply
          env.remote.fs.file_write path, content
        end

        def path
          arguments[0]
        end

        def content
          arguments[1]
        end
      end
    end
  end
end
