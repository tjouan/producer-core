module Producer
  module Core
    class Env
      attr_reader   :current_recipe
      attr_accessor :target

      def initialize(recipe)
        @current_recipe = recipe
        @target         = nil
      end
    end
  end
end
