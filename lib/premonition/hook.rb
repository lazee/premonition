module Jekyll
  module Premonition
    class Hook < Generator
      safe true
      priority :low

      def initialize(p)
        super(p)
      end

      def generate(site)
        @resources = Resources.new site.config
        Hooks.register [:documents, :pages], :pre_render do |doc|
          adder(doc)
        end
      end

      def adder(doc)
        o = []
        b = nil
        doc.content.each_line do |l|
          if blockquote?(l) && empty_block?(b)
            if (m = l.match(/^\>\s+([a-z]+)\s+\"(.*)\"$/i))
              y, t = m.captures
              b = { 'title' => t.strip, 'type' => y.strip.downcase, 'content' => [] }
            else
              o << l
            end
          elsif blockquote?(l) && !empty_block?(b)
            b['content'] << l.match(/^\>\s?(.*)$/i).captures[0]
          else
            if !blockquote?(l) && !empty_block?(b)
              o << render_block(b)
              b = nil
            end
            o << l
          end
        end
        o << render_block(b) unless empty_block?(b)
        doc.content = o.join
      end

      def blockquote?(l)
        l.strip.start_with?('>')
      end

      def empty_block?(b)
        b.nil?
      end

      def render_block(b)
        t = create_resource(b)
        c = "#{@resources.markdown.convert(b['content'].join("\n"))}\n\n"
        template = Liquid::Template.parse(t['template'], error_mode: :strict)
        template.render(
          {
            'header' => !t['title'].nil?,
            'title' => t['title'],
            'content' => c,
            'type' => b['type'],
            'meta' => t['meta']
          },
          strict_variables: true
        )
      end

      def create_resource(b)
        c = {
          'template' => @resources.config['default']['template'],
          'title' => @resources.config['default']['title'],
          'meta' => @resources.config['default']['meta']
        }
        @resources.config['types'].each do |id, t|
          next unless id == b['type']
          c['title'] = b['title'].empty? || b['title'].nil? ? t['default_title'] : b['title']
          c['template'] = t['template'] unless t['template'].nil?
          c['meta'] = c['meta'].merge(t['meta']) unless t['meta'].nil?
        end
        c
      end
    end
  end
end
