module Producer
  module Core
    module Tests
      class HasFile < Test
        def verify
          fs.file? arguments.first
        end
      end
    end
  end
end
