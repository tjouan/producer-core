module Producer
  module Core
    class Template
      class ERBRenderer
        class << self
          def render file_path, variables = {}
            tpl = ERB.new(File.read(file_path), nil, '-')
            tpl.filename = file_path.to_s
            tpl.result build_erb_binding variables
          end

        protected

          def build_erb_binding variables
            Object.new.instance_eval do |o|
              variables.each do |k, v|
                o.instance_variable_set "@#{k}", v
              end
              binding
            end
          end
        end
      end
    end
  end
end
