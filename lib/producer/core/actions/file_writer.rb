module Producer
  module Core
    module Actions
      class FileWriter < Action
        def setup
          check_arguments_size! arguments_size
          @path, @content = arguments
          convert_options mode: :permissions, user: :owner
        end

        def name
          'file_write'
        end

        def apply
          fs.file_write @path, @content
          fs.setstat @path, options unless options.empty?
        end

      private

        def arguments_size
          2
        end
      end
    end
  end
end
