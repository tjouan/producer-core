module Producer::Core
  describe Template::ERBRenderer do
    include FixturesHelpers

    let(:path) { fixture_path_for 'templates/basic.erb' }

    describe '.render' do
      it 'renders ERB templates' do
        expect(described_class.render path).to eq "basic template\n"
      end

      context 'when variables are given' do
        let(:path) { fixture_path_for 'templates/variables.erb' }

        it 'declares given variables in ERB render binding' do
          expect(described_class.render path, foo: 'bar').to eq "bar\n"
        end
      end
    end
  end
end
