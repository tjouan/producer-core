module Producer
  module Core
    class Env
      attr_reader :current_recipe

      def initialize(recipe)
        @current_recipe = recipe
      end
    end
  end
end
