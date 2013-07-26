module Cucumber
  class Runtime
    alias :old_step_match :step_match

    def step_match(step_name, name_to_report = nil)
      if step_name.include? ' must '
        name_to_report = step_name.dup
        step_name.gsub! ' must ', ' should '
      end

      old_step_match(step_name, name_to_report)
    end
  end
end

require 'aruba/cucumber'


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
