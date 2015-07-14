module Producer
  module Core
    module Actions
      class Mkdir < Action
        def setup
          check_arguments_size! 1
          @path = Pathname.new(arguments.first)
          convert_options mode: :permissions, user: :owner
        end

        def name
          'mkdir'
        end

        def apply
          @path.descend do |path|
            next if fs.dir? path
            fs.mkdir path.to_s
            fs.setstat path.to_s, options unless options.empty?
          end
        end
      end
    end
  end
end
