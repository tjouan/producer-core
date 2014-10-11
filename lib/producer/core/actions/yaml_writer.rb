module Producer
  module Core
    module Actions
      class YAMLWriter < FileWriter
        def setup
          super
          @content = options.delete(:data).to_yaml
        end

        def name
          'yaml_write'
        end


        private

        def arguments_size
          1
        end
      end
    end
  end
end
