# frozen_string_literal: true

module Dotini
  # Key/value pair, with optional prepended and inline comments
  class KeyValuePair
    attr_accessor :key, :value, :prepended_comments, :inline_comment
    attr_writer :value

    def initialize
      @key = nil
      @value = nil
      @prepended_comments = []
      @inline_comment = nil
    end
  end
end
