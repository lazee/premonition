module Jekyll
  module Premonition
    class Hook < Generator
      safe true
      priority :high

      def initialize(p)
        super(p)
      end

      def generate_excerpt?(doc)
        !doc.data['excerpt_separator'].empty?
      end

      def process?(resources, doc)
        resources.config['extensions'].include?(File.extname(doc.relative_path)[1..-1])
      end

      def generate(site)
        resources = Resources.new site.config
        processor = Processor.new resources

        Hooks.register [:posts], :pre_render do |doc|
          if process?(resources, doc)
            doc.content = processor.adder(doc.content)
            doc.data['excerpt'] = Jekyll::Excerpt.new(doc) if generate_excerpt? doc
          end
        end

        Hooks.register [:pages], :pre_render do |doc|
          doc.content = processor.adder(doc.content) if process?(resources, doc)
        end
      end
    end
  end
end
