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
