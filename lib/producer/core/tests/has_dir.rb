module Producer
  module Core
    module Tests
      class HasDir < Test
        def verify
          fs.dir? arguments.first
        end
      end
    end
  end
end
