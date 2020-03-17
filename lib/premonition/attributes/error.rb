# frozen_string_literal: true

require 'strscan'

module Jekyll
  module Premonition
    module Attributes
      # Public: Custom error for Premonition attributes parser errors.
      class ParserError < StandardError
        # Initialize a new ParserError
        #
        # msg - The error message
        # raw - The raw string send to the parser initially.
        #       Used for syntax error output. If nil syntax
        #       error output is skipped.
        # pos - The buffer position when error was raised.
        #       Used in both error message and syntax error output
        #       if raw attribute is set.
        def initialize(msg, raw = nil, pos = 0)
          if raw.nil?
            super(msg)
          else
            super("#{msg} [#{pos}:#{raw.length}]")
            print "Attribute syntax error:\n #{raw}\n"
            pos.times { print ' ' }
            print "^\n"
          end
        end
      end
    end
  end
end
