# frozen_string_literal: true

module Dotini
  # Representation of a INI file
  class IniFile
    DEFAULT_KEY_PATTERN = /[^=\s]+/.freeze
    DEFAULT_VALUE_PATTERN = /(?:"[^"]*"|[^=\s]*)/.freeze

    attr_accessor :sections

    def initialize
      @sections = []
    end

    def [](name)
      sections.find { |section| section.name == name }
    end

    def to_s
      buffer = StringIO.new
      sections.each do |section|
        buffer << section.to_s
      end
      buffer.string
    end

    class << self
      def load(filename,
               comment_character = ';',
               key_pattern = DEFAULT_KEY_PATTERN,
               value_pattern = DEFAULT_VALUE_PATTERN)
        line_pattern = /\A(?<key>#{key_pattern})\s*=\s*(?<value>#{value_pattern})(?:\s*(?<inline_comment>#{comment_character}.*))?\z/
        ini_file = IniFile.new
        current_section = Section.new(nil)
        current_key_value_pair = KeyValuePair.new
        File.open(filename, 'r') do |f|
          f.each_line(chomp: true) do |line|
            line.strip!
            if line.start_with?(comment_character)
              current_key_value_pair.prepended_comments << line
            elsif (match = line.match(/\A\[(?<section_name>[^\]]+)\]\z/))
              current_section.key_value_pairs << current_key_value_pair
              ini_file.sections << current_section
              current_section = Section.new(match['section_name'])
              current_key_value_pair = KeyValuePair.new
            elsif (match = line.match(line_pattern))
              current_key_value_pair.key = match['key']
              current_key_value_pair.value = match['value']
              current_key_value_pair.inline_comment = match['inline_comment']
              current_section.key_value_pairs << current_key_value_pair
              current_key_value_pair = KeyValuePair.new
            end
          end
        end
        current_section.key_value_pairs << current_key_value_pair
        ini_file.sections << current_section

        ini_file
      end
    end
  end
end
