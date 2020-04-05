# frozen_string_literal: true

require 'strscan'

module Jekyll
  module Premonition
    module Attributes
      # Public: Premonition block attributes parser.
      #
      # Parses attributes found in block headers like this:
      # > "info" [ foo = abcd, bar = "zot", size = 3  ]
      #
      # The parser itself utilizes the StringScanner in ruby.
      # Each character will be parsed, validated and pushed
      # to a stack (array) according to the rules inside the
      # parser itself.
      #
      # A stack object will be of a certain type:
      #
      # 0 : Outside an attributes block
      # 1 : Inside an attributes block, but between keys or values
      # 2 : Parsing an attribute key
      # 3:  Parsing an attribute value
      #
      # Upon parser errors a pretty syntax error will be printed to
      # stdout, showing where the error is.
      class Parser
        # Get parsed attributes as a Hash
        attr_reader :attributes

        # Initialize a new Parser AND start parsing
        #
        # str          - A string containing the attributes block to be parser.
        def initialize(str)
          @raw = str                       # Keeps th original string for later use
          @buffer = StringScanner.new(str) # Create StringScanner buffer
          @attributes = {}                 # Initialize the attributes hash
          @stack = [Stacker.new(0)]        # Initialize the parser stack with initial "state"
          parse                            # Start parsing
        end

        private

        def parse
          raise error('No attributes block found in given string') unless @raw.match(/^.*\[.*\].*/)

          until @buffer.eos?
            char = @buffer.getch
            case @stack.last.type
            when 0 # Outside block mode
              push_stacker(1) if char == '['
            when 1 # In between
              parse_in_between(char)
            when 2 # Key
              parse_key(char)
            when 3 # Value
              parse_value(char)
            end
          end
        end

        def parse_in_between(char)
          return if char == ' ' # Ignoring all spaces before, between and after keys and values.

          if char == ']'
            pop_attribute_from_stack
            push_stacker(4)
          elsif char == ','
            raise error("Attribute separator ',' not allowed here.") if @attributes.length.zero?
            push_stacker(2)
          elsif char.match(/^[a-zA-z0-9\-_]$/)
            push_stacker(2)
            append_char(char)
          else
            raise error("Illegal character '#{char}' outside key and value")
          end
        end

        def parse_key(char)
          if char == '='
            push_stacker(3)
            value_mode('plain')
          elsif char.match(/^[a-zA-z0-9\-_]$/)
            append_char(char)
          elsif char == ' '
            m = @buffer.scan(/\s*\=\s*/)
            raise error('Space not allowed inside attribute key') if m.nil?
            push_stacker(3)
            value_mode('plain')
          else
            raise error("Illegal character '#{char}' for attribute key")
          end
        end

        def parse_value(char)
          case char
          when ']'
            if plain_mode?
              pop_attribute_from_stack
              push_stacker(4)
            end
          when '"'
            pop_attribute_from_stack unless plain_mode?
            raise error('Illegal " found') unless @stack.last.value.nil? || @stack.last.value.empty?
            value_mode('block')
          when '\\'
            raise error('Backslash is not allowed in unquoted values') if plain_mode?
            raise error('Unsupported escaping of character inside string block') unless ['\\', '"'].include?(@buffer.peek(1))
            append_char(@buffer.peek(1))
            @buffer.pos += 1
          when ','
            if plain_mode?
              pop_attribute_from_stack
              push_stacker(1)
            else
              append_char(char)
            end
          when '='
            raise error('Illegal use of equals character in unquoted value') if plain_mode?
            append_char(char)
          when ' '
            if plain_mode?
              raise error('Illegal spacing in unquoted value') if @buffer.check(/\s*[,\]]/).nil?
              pop_attribute_from_stack
              push_stacker(1)
            else
              append_char(char)
            end
          else
            append_char(char)
          end
        end

        def error(msg)
          ParserError.new(msg, @raw, @buffer.pos)
        end

        def push_stacker(type)
          @stack << Stacker.new(type)
        end

        def append_char(char)
          @stack.last.append(char)
        end

        def pop_attribute_from_stack
          v = @stack.pop
          return if [0, 1, 2].include?(v.type) # Ignore these types from stack
          k = @stack.pop
          raise error("Expected key but got: #{k.value}, #{k.type}") unless k.type == 2
          @attributes[k.value] = v.value
        end

        def plain_mode?
          @stack.last.meta['mode'] == 'plain'
        end

        def block_mode?
          @stack.last.meta['mode'] == 'block'
        end

        def value_mode(str)
          @stack.last.meta['mode'] = str
        end
      end
    end
  end
end
