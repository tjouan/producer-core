require 'spec_helper'

module Producer::Core
  describe Action do
    it_behaves_like 'action'

    describe '#name' do
      subject(:action) { described_class.new(double 'env') }

      it 'infers action name from class name' do
        expect(action.name).to eq 'action'
      end
    end
  end
end
