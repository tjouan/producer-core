module Producer
  module Core
    module Actions
      class Mkdir < Action
        def name
          'mkdir'
        end

        def apply
          path.descend do |p|
            next if fs.dir? p
            fs.mkdir p.to_s
            fs.chmod p.to_s, mode if mode
          end
        end


        private

        def path
          Pathname.new(arguments.first)
        end

        def mode
          arguments[1]
        end
      end
    end
  end
end
