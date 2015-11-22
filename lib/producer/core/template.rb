module Producer
  module Core
    class Template
      SEARCH_PATH = 'templates'.freeze
      RENDERERS   = {
        ERBRenderer   => %i[erb],
        YAMLRenderer  => %i[yaml]
      }.freeze

      def initialize path, search_path: SEARCH_PATH, renderers: RENDERERS
        @path         = Pathname.new(path)
        @search_path  = Pathname.new(search_path)
        @renderers    = renderers
      end

      def render variables = {}
        candidates.each do |c|
          r, _ = @renderers.find { |k, v| v.include? c.extname[1..-1].to_sym }
          return r.render c, variables if r
        end

        fail TemplateMissingError, "template `#{@path.to_s}' not found"
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
