module Producer
  module Core
    module Actions
      class Mkdir < Action
        def name
          'mkdir'
        end

        def apply
          case arguments.size
          when 1
            fs.mkdir path
          when 2
            fs.mkdir path, mode
          end
        end


        private

        def path
          arguments.first
        end

        def mode
          arguments[1]
        end
      end
    end
  end
end
