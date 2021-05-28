# frozen_string_literal: true

module Dotini
  # Key/value pair, with optional prepended and inline comments
  class KeyValuePair
    attr_accessor :key, :value, :prepended_comments, :inline_comment

    def initialize
      @key = nil
      @value = nil
      @prepended_comments = []
      @inline_comment = nil
    end

    def to_s
      buffer = StringIO.new
      prepended_comments.each do |line|
        buffer << line << "\n"
      end

      unless key.nil?
        buffer << "#{key} = #{value}"
        buffer <<
          if inline_comment.nil?
            "\n"
          else
            " #{inline_comment}\n"
          end
      end

      buffer.string
    end
  end
end
