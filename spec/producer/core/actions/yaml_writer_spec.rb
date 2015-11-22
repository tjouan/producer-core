module Producer::Core
  module Actions
    RSpec.describe YAMLWriter, :env do
      let(:path)        { 'some_path' }
      let(:data)        { { foo: 'bar' } }
      let(:arguments)   { [path] }
      let(:options)     { { data: data } }
      subject(:writer)  { described_class.new(env, *arguments, options) }

      it_behaves_like 'action'

      it { is_expected.to be_a FileWriter}

      describe '#apply' do
        it 'writes data as YAML to file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, data.to_yaml)
          writer.apply
        end
      end
    end
  end
end
