module Producer::Core
  class Remote
    describe Environment do
      let(:string)          { "FOO=bar\nBAZ=qux" }
      let(:argument)        { variables }

      describe '.string_to_hash' do
        it 'converts key=value pairs separated by new lines to a hash' do
          expect(described_class.string_to_hash(string)).to eq ({
            'FOO' => 'bar',
            'BAZ' => 'qux'
          })
        end
      end
    end
  end
end
