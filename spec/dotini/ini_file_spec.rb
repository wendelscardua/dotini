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
          expect(ini_file[nil].name).to eq nil
          expect(ini_file['main'].name).to eq 'main'
          expect(ini_file['profile foo'].name).to eq 'profile foo'
          expect(ini_file['profile bar'].name).to eq 'profile bar'
        end

        it 'fetching inexistent sections creates new sections' do
          expect(ini_file['profile quux'].name).to eq 'profile quux'
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

    describe 'to_h' do
      context 'when instantiated from a basic INI file' do
        let(:ini_file) { described_class.load(example_ini) }
        let(:example_content) do
          {
            'main' => {
              'path' => '/home/user/me',
              'compiler' => 'gcc'
            },
            'profile foo' => {
              'path' => '/home/user/foo',
              'compiler' => 'ca65'
            },
            'profile bar' => {
              'public_key' => '"3.1415926"'
            }
          }
        end

        it 'results in a hash version of the content, without comments' do
          expect(ini_file.to_h).to eq example_content
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

    describe 'write' do
      context 'when instantiated from a basic INI file' do
        let(:ini_file) { described_class.load(example_ini) }

        it 'results in a similar content, without blank lines, written to io stream' do
          io_stream = StringIO.new
          ini_file.write(io_stream)
          expect(io_stream.string).to eq File.read(example_ini).gsub(/^\s*\n/, '')
        end
      end
    end
  end
end
