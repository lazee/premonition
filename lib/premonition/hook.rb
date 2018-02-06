module Jekyll
  module Premonition
    class Hook < Generator
      safe true
      priority :low
      attr_reader :resources

      def initialize(p)
        super(p)
        unless defined?(Redcarpet)
          Jekyll::External.require_with_graceful_fail(
            "redcarpet (in #{__FILE__})"
          )
        end
      end

      def generate(site)
        @resources = Resources.new site
        add_hook
      end

      def add_hook
        Hooks.register :documents, :pre_render do |doc|
          o = []
          b = nil
          doc.content.each_line do |l|
            if blockquote?(l) && empty_block?(b)
              if (m = l.match(/^\>\s+([a-z]+)\s+\"(.*)\"$/i))
                y, t = m.captures
                b = { title: t.strip, type: y.strip.downcase, content: [] }
              else
                o << l
              end
            elsif blockquote?(l) && !empty_block?(b)
              b[:content] << l.match(/^\>(.*)$/i).captures[0].strip
            else
              if !blockquote?(l) && !empty_block?(b)
                o << render_block(b)
                b = nil
              end
              o << l
            end
          end
          doc.content = o.join
        end
      end

      def blockquote?(l)
        l.strip.start_with?('>')
      end

      def empty_block?(b)
        b.nil?
      end

      def render_block(b)
        t = create_templ(b)
        c = "#{@resources.renderer.render(b[:content].join("\n"))}\n\n"
        v = {
          title: t[:title],
          content: c,
          type: b[:type]
        }
        v[:header] = header(t[:title]) % v
        t[:template] % v
      end

      def header(t)
        t.empty? ? '' : @resources.config[:default][:header_template]
      end

      def create_templ(b)
        c = {
          template: @resources.config[:default][:template],
          title: @resources.config[:default][:title]
        }
        @resources.config[:types].each do |t|
          next unless t[:id] == b[:type]
          c[:title] = b[:title].empty? ? t[:default_title] : b[:title]
          c[:template] = t[:template]
        end
        c
      end
    end
  end
end
