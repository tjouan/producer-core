module Producer
  module Core
    class Template
      SEARCH_PATH = 'templates'.freeze
      RENDERERS   = {
        /\.erb\z/   => ERBRenderer,
        /\.yaml\z/  => YAMLRenderer
      }.freeze

      def initialize path, search_path: SEARCH_PATH, renderers: RENDERERS
        @path         = Pathname.new(path)
        @search_path  = Pathname.new(search_path)
        @renderers    = renderers
      end

      def render variables = {}
        candidates.each do |c|
          _, r = @renderers.find { |k, _| c.to_s =~ k }
          return r.render c, variables if r
        end

        fail TemplateMissingError, "template `#{@path}' not found"
      end

    protected

      def candidates
        if @path.to_s =~ /\A\.\//
          glob_candidates_by_prefix @path
        else
          glob_candidates_by_prefix @search_path + @path
        end
      end

      def glob_candidates_by_prefix path_prefix
        Pathname.glob(path_prefix.to_s + ?*)
      end
    end
  end
end
