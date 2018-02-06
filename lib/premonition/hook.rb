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
        Hooks.register :documents, :pre_render do |doc|
          adder(doc)
        end
        Hooks.register :pages, :pre_render do |page|
          adder(page)
        end
        Hooks.register :posts, :pre_render do |page|
          adder(page)
        end
      end

      def adder(doc)
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
        t = create_templ(b)
        c = "#{@resources.renderer.render(b[:content].join("\n"))}\n\n"
        v = {
          title: t[:title],
          content: c,
          type: b[:type]
        }
        v[:header] = header(t[:title]) % v
        clean_markup(t[:template] % v)
      end

      def clean_markup(r)
        br = '<br>' * 2
        r = r.gsub('<p>', '').gsub('</p>', br).strip
        r = r.gsub(br, '') if r.scan(/<br><br>/m).size == 1
        r
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
