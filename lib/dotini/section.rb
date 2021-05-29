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
      key_value_pairs.find { |key_pair| key_pair.key == key } ||
        KeyValuePair.new.tap do |pair|
          pair.key = key
          key_value_pairs << pair
        end
    end

    def []=(key, value)
      self[key].value = value
    end

    def to_h
      {}.tap do |hash|
        key_value_pairs.each do |pair|
          hash[pair.key] = pair.value
        end
      end
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
