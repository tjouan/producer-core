module Producer
  module Core
    class Template
      class RawRenderer
        class << self
          def render file_path, *_
            File.read(file_path)
          end
        end
      end
    end
  end
end
