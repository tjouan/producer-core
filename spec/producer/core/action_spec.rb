module Producer::Core
  RSpec.describe Action do
    let(:env)         { double 'env'}
    let(:arguments)   { [:some, :arguments] }
    let(:options)     { { foo: :bar } }
    subject(:action)  { described_class.new(env, *arguments, options) }

    it_behaves_like 'action'

    describe '#initialize' do
      it 'calls #setup when defined' do
        action_class = Class.new(described_class)
        action_class.class_eval do
          define_method(:setup) { @arguments = :other_arguments }
        end
        expect(action_class.new(env).arguments).to eq :other_arguments
      end
    end

    describe '#name' do
      it 'infers action name from class name' do
        expect(action.name).to eq 'action'
      end
    end

    describe '#to_s' do
      it 'includes action name' do
        expect(action.to_s).to match /\A#{action.name}/
      end

      it 'includes arguments inspection' do
        expect(action.to_s).to match /#{Regexp.quote(arguments.inspect)}\z/
      end

      context 'when arguments inspection is very long' do
        let(:arguments)   { [:some, :arguments] * 32 }

        it 'summarizes arguments inspection' do
          expect(action.to_s.length).to be < 70
        end
      end
    end
  end
end
