# frozen_string_literal: true

module Dotini
  RSpec.describe Section do
    describe 'to_s' do
      let(:first_key_value_pair) do
        KeyValuePair.new.tap do |pair|
          pair.key = 'first-key'
          pair.value = 'first-value'
          pair.prepended_comments = ['; first']
        end
      end
      let(:second_key_value_pair) do
        KeyValuePair.new.tap do |pair|
          pair.key = 'second-key'
          pair.value = 'second-value'
          pair.inline_comment = '; second'
        end
      end
      let(:key_value_pairs) { [first_key_value_pair, second_key_value_pair] }

      context 'when there is no name' do
        context 'when there are no pairs' do
          subject(:section) do
            described_class.new(nil)
          end
          it 'returns an empty string' do
            expect(section.to_s).to eq ''
          end
        end

        context 'when there are some pairs' do
          subject(:section) do
            described_class.new(nil).tap do |section|
              section.key_value_pairs = key_value_pairs
            end
          end
          it 'returns a valid string without sections' do
            expect(section.to_s).to eq "; first\nfirst-key = first-value\nsecond-key = second-value ; second\n"
          end
        end
      end

      context 'when there is a name' do
        context 'when there are no pairs' do
          subject(:section) do
            described_class.new('profile x')
          end
          it 'returns an empty string' do
            expect(section.to_s).to eq "[profile x]\n"
          end
        end

        context 'when there are some pairs' do
          subject(:section) do
            described_class.new('profile x').tap do |section|
              section.key_value_pairs = key_value_pairs
            end
          end
          it 'returns a valid string with a section' do
            expect(section.to_s).to eq "[profile x]\n; first\nfirst-key = first-value\nsecond-key = second-value ; second\n"
          end
        end
      end
    end
  end
end
