require 'spec_helper'

module Producer::Core
  describe Template::YAMLRenderer do
    include FixturesHelpers

    let(:path) { fixture_path_for 'templates/basic_yaml.yaml' }

    describe '.render' do
      it 'renders YAML templates' do
        expect(described_class.render path).to eq({ 'foo' => 'bar' })
      end
    end
  end
end
