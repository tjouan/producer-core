require 'spec_helper'

module Producer::Core
  describe Action do
    let(:env)         { double 'env'}
    subject(:action)  { described_class.new(env) }

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
  end
end
