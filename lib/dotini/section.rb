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
  end
end
