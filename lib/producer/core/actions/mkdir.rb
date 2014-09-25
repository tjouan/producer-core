module Producer
  module Core
    module Actions
      class Mkdir < Action
        def name
          'mkdir'
        end

        def apply
          Pathname.new(path).descend do |p|
            next if fs.dir? p
            case arguments.size
            when 1 then fs.mkdir p.to_s
            when 2 then fs.mkdir p.to_s, mode
            end
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
