# frozen_string_literal: true

require 'strscan'

module Jekyll
  module Premonition
    module Attributes
      # Instances of this class are pushed onto the parser stack upon parsing of block attributes.
      class Stacker
        # Get the string value from the stacker
        attr_reader :value
        # Get the stacker type. 0 = outside block, 1 = in_between, 2 = key, 3 = value
        attr_reader :type
        # Get and set meta attributes for stacker. Used for setting value mode.
        attr_accessor :meta

        # Initialize a new Stacker
        #
        # type - The stacker type
        def initialize(type)
          @value = nil
          @type = type
          @meta = {}
        end

        # Append a char to the stacker value
        def append(char)
          @value = @value.nil? ? char : "#{@value}#{char}"
        end
      end
    end
  end
end
