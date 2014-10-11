module Producer
  module Core
    module Tests
      class YAMLEq < Test
        def verify
          return false unless file_content = fs.file_read(arguments.first)
          YAML.load(file_content) == arguments[1]
        end
      end
    end
  end
end
