# frozen_string_literal: true

module Dotini
  # A single INI file section
  class Section
    attr_accessor :name, :key_value_pairs

    def initialize(name)
      @name = name
      @key_value_pairs = []
    end

    def [](key)
      @key_value_pairs.find { |key_pair| key_pair.key == key }
    end

    def to_s
      buffer = StringIO.new
      buffer << "[#{name}]\n" unless name.nil?
      key_value_pairs.each do |pair|
        buffer << pair.to_s
      end
      buffer.string
    end
  end
end
