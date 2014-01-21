require 'spec_helper'

module Producer::Core
  describe Prompter do
    let(:input)         { StringIO.new }
    let(:output)        { StringIO.new }
    let(:env)           { Env.new(input: input, output: output) }
    subject(:prompter)  { Prompter.new(input, output) }

    describe '#initialize' do
      it 'assigns the given input' do
        expect(prompter.input).to be input
      end

      it 'assigns the given output' do
        expect(prompter.output).to be output
      end
    end

    describe '#prompt' do
      let(:question)  { 'Which letter?' }
      let(:choices)   { [[:a, ?A], [:b, ?B]] }

      it 'prompts choices' do
        prompter.prompt question, choices
        expect(output.string).to eq <<-eoh.gsub /^\s+\|/, ''
          |#{question}
          |0: A
          |1: B
          |Choice:
        eoh
      end

      it 'returns value for entry chosen by user' do
        input.puts '1'
        input.rewind
        expect(prompter.prompt question, choices).to eq :b
      end
    end
  end
end
