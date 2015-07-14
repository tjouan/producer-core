module Producer
  module Core
    class Template
      SEARCH_PATH = 'templates'.freeze

      def initialize path, search_path: SEARCH_PATH
        @path         = Pathname.new(path)
        @search_path  = Pathname.new(search_path)
      end

      def render variables = {}
        case (file_path = resolve_path).extname
        when '.yaml'  then render_yaml file_path
        when '.erb'   then render_erb file_path, variables
        end
      end

    private

      def render_erb file_path, variables = {}
        tpl = ERB.new(File.read(file_path), nil, '-')
        tpl.filename = file_path.to_s
        tpl.result build_erb_binding variables
      end

      def render_yaml file_path
        YAML.load(File.read(file_path))
      end

      def resolve_path
        if @path.to_s =~ /\A\.\//
          resolve_suffix @path
        else
          resolve_suffix @search_path + @path
        end
      end

      def resolve_suffix path
        Pathname.glob("#{path}.{erb,yaml}").first
      end

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
