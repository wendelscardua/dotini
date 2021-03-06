# frozen_string_literal: true

module Dotini
  # Representation of a INI file
  class IniFile
    DEFAULT_KEY_PATTERN = /[^=\s]+/.freeze
    DEFAULT_VALUE_PATTERN = /(?:"[^"]*"|[^=\s]*)/.freeze

    attr_accessor :sections

    # Creates a new, empty INI file
    def initialize
      @sections = []
    end

    # Retrieves an existing section, or creates a new one
    def [](name)
      sections.find { |section| section.name == name } ||
        Section.new(name).tap { |section| sections << section }
    end

    # Represents the current INI file as a hash
    def to_h
      {}.tap do |hash|
        sections.each do |section|
          section.to_h.then do |section_hash|
            next if section_hash.empty?

            (hash[section.name] ||= {}).merge! section_hash
          end
        end
      end
    end

    # Represents the current INI file as a string
    def to_s
      buffer = StringIO.new
      sections.each do |section|
        buffer << section.to_s
      end
      buffer.string
    end

    def write(io_stream)
      io_stream.write(to_s)
    end

    class << self
      # Loads an INI file by name
      # The options are:
      # - comment_character: which character is used for comments
      # - key_pattern: a regexp that matches the property keys
      # - value_pattern: a regexp that matches the property values
      def load(filename,
               comment_character: ';',
               key_pattern: DEFAULT_KEY_PATTERN,
               value_pattern: DEFAULT_VALUE_PATTERN)
        line_pattern = /\A(?<key>#{key_pattern})
                        \s*=\s*
                        (?<value>#{value_pattern})
                        (?:\s*(?<inline_comment>#{comment_character}.*))?\z/x
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
