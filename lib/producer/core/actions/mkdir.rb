module Producer
  module Core
    module Actions
      class Mkdir < Action
        def setup
          check_arguments_size! 1
          @path = Pathname.new(arguments.first)
          @options[:permissions]  = @options.delete :mode if @options.key? :mode
          @options[:owner]        = @options.delete :user if @options.key? :user
        end

        def name
          'mkdir'
        end

        def apply
          @path.descend do |p|
            next if fs.dir? p
            fs.mkdir p.to_s
            fs.setstat p.to_s, @options unless @options.empty?
          end
        end
      end
    end
  end
end
