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
        # default_attr - If set, then this value will be used as the key if
        #                only a single value is given within the attributes
        #                block. Eg: if set to 'foo' and attributes block is
        #                '[ "bar" ]', then an attribute { 'foo' => 'bar' } is
        #                added to the parsed attributes.
        #                NB: This works for one attribute only.
        def initialize(str, default_attr = nil)
          @raw = str                       # Keeps th original string for later use
          @buffer = StringScanner.new(str) # Create StringScanner buffer
          @attributes = {}                 # Initialize the attributes hash
          @stack = [Stacker.new(0)]        # Initialize the parser stack with initial "state"
          parse(default_attr)              # Start parsing
        end

        private

        def parse(_default_attr)
          raise error('No attributes block found in given string') unless @raw.match(/^.*\[.*\].*/)

          until @buffer.eos?
            char = @buffer.getch

            case @stack.last.type
            when 0 # Outside block mode
              push(1) if char == '['
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
            pop_attr
            push(4)
          elsif char == ','
            raise error("Attribute separator ',' not allowed here.") if @attributes.length.zero?

            push(2)
          elsif char.match(/^[a-zA-z0-9\-_]$/)
            push(2)
            @stack.last.append(char)
          else
            raise error("Illegal character '#{char}' outside key and value")
          end
        end

        def parse_key(char)
          if char == '='
            push(3)
            @stack.last.meta['mode'] = 'plain'
          elsif char.match(/^[a-zA-z0-9\-_]$/)
            @stack.last.append(char)
          elsif char == ' '
            m = @buffer.scan(/\s*\=\s*/)
            raise error('Space not allowed inside attribute key') if m.nil?

            push(3)
            @stack.last.meta['mode'] = 'plain'
          else
            raise error("Illegal character '#{char}' for attribute key")
          end
        end

        def parse_value(char)
          case char
          when '"'
            if @stack.last.meta['mode'] == 'plain'
              raise error('Illegal " found') unless @stack.last.value.nil? || @stack.last.value.empty?
              @stack.last.meta['mode'] = 'block'
            else
              pop_attr
            end
          when '\\'
            if @stack.last.meta['mode'] == 'block'
              unless ['\\', '"'].include?(@buffer.peek(1))
                raise error('Unsupported escaping of character inside string block')
              end
              @stack.last.append(@buffer.peek(1))
              @buffer.pos += 1
            else
              raise error('Backslash is not allowed in unquoted values')
            end
          when ','
            if @stack.last.meta['mode'] == 'plain'
              pop_attr
              push(1)
            else
              @stack.last.append(char)
            end
          when '='
            raise error('Illegal use of equals character in unquoted value') if @stack.last.meta['mode'] == 'plain'

            @stack.last.append(char)
          when ' '
            if @stack.last.meta['mode'] == 'plain'
              raise error('Illegal spacing in unquoted value') if @buffer.check(/\s*,/).nil?

              pop_attr
              push(1)
            else
              @stack.last.append(char)
            end
          else
            @stack.last.append(char)
          end
        end

        def error(msg)
          ParserError.new(msg, @raw, @buffer.pos)
        end

        def push(type)
          @stack << Stacker.new(type)
        end

        def append(char)
          @stack.last.append(char)
        end

        def pop_attr
          v = @stack.pop
          return if [0, 1, 2].include?(v.type) # Ignore these types from stack

          k = @stack.pop
          raise error("Expected key but got: #{k.value}, #{k.type}") unless k.type == 2

          @attributes[k.value] = v.value
        end
      end
    end
  end
end
