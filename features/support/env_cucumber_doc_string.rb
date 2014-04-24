require 'cucumber/formatter/pretty'

module Cucumber
  module Ast
    class DocString
      alias :old_initialize :initialize

      def initialize(string, content_type)
        old_initialize(string + "\n", content_type)
      end
    end
  end

  module Formatter
    class Pretty
      alias :old_doc_string :doc_string

      def doc_string(string)
        old_doc_string(string.chomp)
      end
    end
  end
end
