module Jekyll
  module Premonition
    class Resources
      attr_reader :config
      attr_reader :renderer

      def initialize(site)
        @config = load_config site
        @renderer = create_renderer site
      end

      def create_renderer(site)
        hsh = {}
        ext_lookup(site).each { |a| hsh[a] = true }
        Redcarpet::Markdown.new(Redcarpet::Render::HTML, hsh)
      end

      def ext_lookup(site)
        ((site.config['redcarpet'] || {})['extensions'] || [])
      end

      def load_config(site)
        cfg = create_default_config
        prem = site.config['premonition'] || {}
        df = prem['default'] || {}
        cfg[:default][:template] = df['template'].strip unless df['template'].nil?
        cfg[:default][:header_template] = df['header_template'].strip unless df['header_template'].nil?
        cfg[:default][:title] = df['title'].strip unless df['title'].nil?
        unless prem['types'].nil?
          fail('types configuration must be an array') unless prem['types'].is_a?(Array)
          prem['types'].each { |t| cfg[:types] << load_config_type(t) }
        end
        cfg
      end

      def load_config_type(t)
        validate_config_type(t)
        {
          id: t['id'],
          template: t['template'].strip,
          default_title: (t['default_title'].nil? ? '' : t['default_title'].strip)
        }
      end

      def validate_config_type(t)
        fail('id missing from type') if t['id'].nil?
        fail("id can only be lowercase letters: #{t['id']}") unless t['id'][/[a-z]+/] == t['id']
        fail('template missing from type') if t['template'].nil?
      end

      def create_default_config
        {
          default: {
            template: '<div class="premonition %{type}">%{header}%{content}</div>',
            header_template: ' <span class="header">%{title}</span>',
            title: 'Info'
          },
          types: []
        }
      end

      def fail(msg)
        Jekyll.logger.error 'Fatal (Premonition):', msg
        raise LoadError, msg
      end
    end
  end
end
