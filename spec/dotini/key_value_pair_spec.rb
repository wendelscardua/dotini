# frozen_string_literal: true

module Dotini
  RSpec.describe KeyValuePair do
    describe 'to_s' do
      context 'when there is no key' do
        context 'when there is no comment' do
          subject(:pair) do
            described_class.new
          end

          it 'returns an empty string' do
            expect(pair.to_s).to eq ''
          end
        end

        context 'when there are some prepended comments' do
          subject(:pair) do
            described_class.new.tap do |pair|
              pair.prepended_comments = [
                '; first comment',
                '; second comment'
              ]
            end
          end

          it 'returns a string with just the comments' do
            expect(pair.to_s).to eq "; first comment\n; second comment\n"
          end
        end
      end

      context 'when there is a key' do
        context 'when there is no comment' do
          subject(:pair) do
            described_class.new.tap do |pair|
              pair.key = 'some-key'
              pair.value = 'some-value'
            end
          end

          it 'returns a valid key-pair string' do
            expect(pair.to_s).to eq "some-key = some-value\n"
          end
        end

        context 'when there is an inline comment' do
          subject(:pair) do
            described_class.new.tap do |pair|
              pair.key = 'some-key'
              pair.value = 'some-value'
              pair.inline_comment = '; some-inline-comment'
            end
          end

          it 'returns a valid key-pair string' do
            expect(pair.to_s).to eq "some-key = some-value ; some-inline-comment\n"
          end
        end

        context 'when there are some prepended comments' do
          subject(:pair) do
            described_class.new.tap do |pair|
              pair.key = 'some-key'
              pair.value = 'some-value'
              pair.prepended_comments = [
                '; first comment',
                '; second comment'
              ]
            end
          end

          it 'returns a valid key-pair string' do
            expect(pair.to_s).to eq "; first comment\n; second comment\nsome-key = some-value\n"
          end
        end

        context 'when there are both inline and prepended comments' do
          subject(:pair) do
            described_class.new.tap do |pair|
              pair.key = 'some-key'
              pair.value = 'some-value'
              pair.prepended_comments = ['; foo']
              pair.inline_comment = '; bar'
            end
          end

          it 'returns a valid key-pair string' do
            expect(pair.to_s).to eq "; foo\nsome-key = some-value ; bar\n"
          end
        end
      end
    end
  end
end
