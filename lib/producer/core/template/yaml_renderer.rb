module Producer
  module Core
    class Template
      class YAMLRenderer
        class << self
          def render file_path, *_
            YAML.load(File.read(file_path))
          end
        end
      end
    end
  end
end
