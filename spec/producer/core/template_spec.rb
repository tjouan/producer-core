class DummyRenderer
  class << self
    def render *args
      args
    end
  end
end

module Producer::Core
  RSpec.describe Template do
    include FixturesHelpers

    let(:path)          { 'basic' }
    let(:search_path)   { fixture_path_for 'templates' }
    let(:renderers)     { { DummyRenderer => %i[dummy] } }
    subject :template do
      described_class.new path, search_path: search_path, renderers: renderers
    end

    describe '#render' do
      it 'uses a matching renderer from configured ones' do
        expect(DummyRenderer).to receive :render
        expect(template.render)
      end

      it 'sends full template path to the renderer' do
        expect(template.render[0])
          .to eq Pathname.new("#{search_path}/#{path}.dummy")
      end

      it 'sends given variables to the renderer' do
        expect(template.render(:foo)[1]).to eq :foo
      end

      context 'when template does not exist' do
        let(:path) { 'templates/unknown_template' }

        it 'raises a TemplateMissingError' do
          expect { template.render }.to raise_error TemplateMissingError
        end
      end

      context 'when relative path is given' do
        let(:path) { fixture_path_for('templates/basic').insert 0, './' }

        it 'does not enforce `template\' search path' do
          expect(template.render[0])
            .to eq Pathname.new("#{path}.dummy")
        end
      end
    end
  end
end
