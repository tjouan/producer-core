module Producer
  module Core
    class Prompter
      attr_reader :input, :output

      def initialize(input, output)
        @input  = input
        @output = output
      end

      def prompt(question, choices)
        cs = choices.each_with_index.inject('') do |m, (c, i)|
          m += "#{i}: #{c.last}\n"
        end
        output.puts "#{question}\n#{cs}Choice:"
        choice = input.gets
        choices[choice.to_i].first
      end
    end
  end
end
