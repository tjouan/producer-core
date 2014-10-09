module Producer
  module Core
    module Actions
      class FileWriter < Action
        def setup
          if arguments.compact.size != 2
            fail ArgumentError, '`%s\' action requires 2 arguments' % name
          end

          @path, @content         = arguments
          @options[:permissions]  = @options.delete :mode if options.key? :mode
          @options[:owner]        = @options.delete :user if options.key? :user
        end

        def name
          'file_write'
        end

        def apply
          fs.file_write @path, @content
          fs.setstat @path, @options unless @options.empty?
        end
      end
    end
  end
end
