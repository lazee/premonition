# frozen_string_literal: true

module Jekyll
  module Premonition
    # Registers Premonition hooks in Jekyll.
    #
    # Two hooks are added. One general hook for pages and another special
    # hook for dealing with excerpts within posts.
    #
    # This ladder is really a hack as we scan all Markdown files and insert the
    # excerpt ourselves in the document data. Unfortunately Jekyll prepares
    # the excerpt way to early in the process, preventing us from hooking
    # into it in a prober way. We only support excerpts if the excerpt_separator
    # is explicitly set: https://jekyllrb.com/docs/posts/#post-excerpts
    class Hook < Generator
      safe true
      priority :high

      def initialize(p)
        super(p)
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

        Hooks.register [:documents], :pre_render do |doc|
            doc.content = processor.adder(doc.content) if process?(resources, doc)
        end
        Hooks.register [:pages], :pre_render do |doc|
          doc.content = processor.adder(doc.content) if process?(resources, doc)
        end
    end

      private

      def generate_excerpt?(doc)
        !doc.data['excerpt_separator'].nil? && !doc.data['excerpt_separator'].empty?
      end

      def process?(resources, doc)
        resources.config['extensions'].include?(File.extname(doc.relative_path)[1..-1])
      end
    end
  end
end
