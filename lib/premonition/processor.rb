# frozen_string_literal: true

module Jekyll
  module Premonition
    # Class that does all of the rendering magic within Premonition.
    class Processor
      def initialize(resources)
        @resources = resources
      end

      # Called by the registered pre_render hooks.
      #
      # This function takes markdown content as input and converts
      # all the block quotes, with a Premonition header, into html.
      #
      # content - Markdown content
      def adder(content)
        o = []
        references = load_references(content)
        b = nil
        is_code_block = false
        content.each_line do |l|
          is_code_block = !is_code_block if code_block_line?(l)
          if is_code_block
            o << l
          elsif blockquote?(l) && empty_block?(b)
            if (m = l.to_s.match(/^\s*\>\s+([a-z]+)\s+\"(.*)\"\s+(\[.*\])?\s*$/i))
              y, t, attrs = m.captures
              b = { 'title' => t.strip, 'type' => y.strip.downcase, 'content' => [], 'attrs' => attrs }
            else
              o << l
            end
          elsif blockquote?(l) && !empty_block?(b)
            b['content'] << l.to_s.match(/^\s*\>\s?(.*)$/i).captures[0]
          else
            if !blockquote?(l) && !empty_block?(b)
              o << render_block(b, references)
              b = nil
            end
            o << l
          end
        end
        o << render_block(b, references) unless empty_block?(b)
        o.join
      end

      private

      # Find all the Kramdown reference name links.
      # https://kramdown.gettalong.org/quickref.html#links-and-images
      # https://github.com/lazee/premonition/issues/10
      def load_references(content)
        refs = ["\n"]
        content.each_line do |l|
          unless l.nil? || l == 0 || (l.is_a? String) 
            refs << l if l.to_s.strip!.match(/^\[.*\]:.*\".*\"$/i)
          end
        end
        refs
      end

      def code_block_line?(line)
        line.strip.start_with?('~~~')
      end

      def blockquote?(line)
        line.strip.start_with?('>')
      end

      def empty_block?(block)
        block.nil?
      end

      def render_block(block, references)
        t = create_resource(block)
        a = block['content'] + references
        c = "#{@resources.markdown.convert(a.join("\n"))}\n\n"
        attrs = {}

        unless block['attrs'].nil?
          parser = Jekyll::Premonition::Attributes::Parser.new(block['attrs'])
          attrs = parser.attributes
        end

        template = Liquid::Template.parse(t['template'], error_mode: :strict)
        template.render(
          {
            'header' => !t['title'].nil?,
            'title' => t['title'],
            'content' => c,
            'type' => block['type'],
            'meta' => t['meta'],
            'attrs' => attrs
          },
          strict_variables: true
        )
      end

      def error_template
        <<~TEMPLATE
          <div class="premonition error">
            <div class="fa {{meta.pn-icon}}"></div>
            <div class="content">
              <p class="header">PREMONITION ERROR: Invalid box type</p>
              You have specified an invalid box type "{{type}}". You can customize your own box types in `_config.yml`.
              See documentation for more help.
            </div>
          </div>
        TEMPLATE
      end

      def create_resource(block)
        c = {
          'template' => @resources.config['default']['template'],
          'title' => @resources.config['default']['title'],
          'meta' => @resources.config['default']['meta']
        }

        unless @resources.config['types'].include? block['type']
          c['title'] = ''
          c['meta'] = { 'pn-icon' => 'pn-error' }
          c['template'] = error_template
          return c
        end

        @resources.config['types'].each do |id, t|
          next unless id == block['type']

          c['title'] = block['title'].empty? || block['title'].nil? ? t['default_title'] : block['title']
          c['template'] = t['template'] unless t['template'].nil?
          c['meta'] = c['meta'].merge(t['meta']) unless t['meta'].nil?
        end
        c
      end
    end
  end
end
