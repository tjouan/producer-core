module Producer
  module Core
    class Template
      SEARCH_PATH = 'templates'.freeze

      def initialize(path, search_path: SEARCH_PATH)
        @path         = Pathname.new("#{path}.erb")
        @search_path  = Pathname.new(search_path)
      end

      def render(variables = {})
        tpl = ERB.new(File.read(resolve_path), nil, '-')
        tpl.filename = resolve_path.to_s
        tpl.result build_erb_binding variables
      end


      private

      def resolve_path
        if @path.to_s =~ /\A\.\// then @path else @search_path + @path end
      end

      def build_erb_binding(variables)
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
