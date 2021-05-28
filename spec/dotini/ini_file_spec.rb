# frozen_string_literal: true

RSpec.describe Dotini::IniFile do
  def file_fixture(filename)
    Pathname.new(File.join(File.dirname(__FILE__), filename))
  end

  describe 'load' do
    context 'when parsing a basic INI file' do
      let(:ini_file) { described_class.load(file_fixture('example.ini')) }

      it 'parses the file with no errors' do
        expect { ini_file }.not_to raise_error
      end

      it 'detects sections correctly' do
        expect(ini_file[nil]).not_to be_nil
        expect(ini_file['main']).not_to be_nil
        expect(ini_file['profile foo']).not_to be_nil
        expect(ini_file['profile bar']).not_to be_nil
      end

      it 'does not detect inexistent sections' do
        expect(ini_file['profile quux']).to be_nil
      end

      it 'detects basic key-value pair correctly' do
        expect(ini_file['main']['path'].value).to eq '/home/user/me'
      end

      it 'detects key-value pair with inline comment correctly' do
        expect(ini_file['main']['compiler'].value).to eq 'gcc'
      end

      it 'detects key-value pairs with quoted values correctly' do
        expect(ini_file['profile bar']['public_key'].value).to eq '"3.1415926"'
      end

      it 'injects inline comment metadata correctly' do
        expect(ini_file['main']['compiler'].inline_comment).to eq '; this is an inline comment'
      end

      it 'injects prepended comments metadata correctly' do
        prepended_comments = [
          '; first comment about foo compiler',
          '; second comment about foo compiler'
        ]
        expect(ini_file['profile foo']['compiler'].prepended_comments).to eq(prepended_comments)
      end
    end
  end
end
