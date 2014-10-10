require 'spec_helper'

module Producer::Core
  describe Template do
    include FixturesHelpers

    let(:path)          { 'basic' }
    let(:search_path)   { fixture_path_for 'templates' }
    subject(:template)  { described_class.new path, search_path: search_path }

    describe '#render' do
      it 'renders ERB templates' do
        expect(template.render).to eq "basic template\n"
      end

      context 'yaml templates' do
        let(:path) { 'basic_yaml' }

        it 'renders yaml templates' do
          expect(template.render).to eq({ 'foo' => 'bar' })
        end
      end

      context 'when variables are given' do
        let(:path) { 'variables' }

        it 'declares given variables in ERB render binding' do
          expect(template.render foo: 'bar').to eq "bar\n"
        end
      end

      context 'when relative path is requested' do
        let(:path) { fixture_path_for('templates/basic').insert 0, './' }

        it 'does not enforce `template\' search path' do
          expect(template.render).to eq "basic template\n"
        end
      end
    end
  end
end
