module Producer
  module Core
    module Tests
      class HasFile < Test
        def success?
          env.remote.fs.has_file? arguments.first
        end
      end
    end
  end
end
