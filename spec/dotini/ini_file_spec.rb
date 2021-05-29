# frozen_string_literal: true

module Dotini
  RSpec.describe IniFile do
    let(:example_ini) { Pathname.new(File.join(File.dirname(__FILE__), 'example.ini')) }

    describe 'load' do
      context 'when parsing a basic INI file' do
        let(:ini_file) { described_class.load(example_ini) }

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

    describe 'to_s' do
      context 'when instantiated from a basic INI file' do
        let(:ini_file) { described_class.load(example_ini) }

        it 'results in a similar content, without blank lines' do
          expect(ini_file.to_s).to eq File.read(example_ini).gsub(/^\s*\n/, '')
        end
      end
    end
  end
end
