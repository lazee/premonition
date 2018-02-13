module Jekyll
  module Premonition
    class Resources
      attr_reader :config
      attr_reader :renderer

      def initialize(site_config)
        @config = load_config site_config
        @renderer = create_renderer site_config
      end

      def create_renderer(site_config)
        hsh = {}
        ext_lookup(site_config).each { |a|
          hsh[a] = true
        }
        Redcarpet::Markdown.new(Redcarpet::Render::HTML, hsh)
      end

      def ext_lookup(site_config)
        ((site_config['redcarpet'] || {})['extensions'] || [])
      end

      def load_config(site_config)
        cfg = create_default_config
        prem = site_config['premonition'] || {}
        df = prem['default'] || {}
        unless df['header_template'].nil?
          fail('header_template config is no longer supported by Premonition. '\
            'See upgrade doc on https://github.com/amedia/premonition ')
        end
        cfg[:default][:template] = df['template'].strip unless df['template'].nil?
        cfg[:default][:title] = df['title'].strip unless df['title'].nil?
        unless df['meta'].nil?
          fail('meta configuration must be an hash') unless df['meta'].is_a?(Hash)
          cfg[:default][:meta] = cfg[:default][:meta].merge(df['meta'])
        end
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
          template: (t['template'].nil? ? nil : t['template'].strip),
          default_title: (t['default_title'].nil? || t['default_title'].empty? ? nil : t['default_title'].strip),
          meta: (t['meta'].nil? ? {} : t['meta'])
        }
      end

      def validate_config_type(t)
        fail('id missing from type') if t['id'].nil?
        fail("id can only be lowercase letters: #{t['id']}") unless t['id'][/[a-z]+/] == t['id']
        fail('meta configuration must be an hash') if !t['meta'].nil? && !t['meta'].is_a?(Hash)
      end

      def create_default_config
        {
          default: {
            template: '<div class="premonition {{type}}"><div class="fa {{meta.fa-icon}}"></div>'\
              '<div class="content">{% if header %}<p class="header">{{title}}</p>{% endif %}{{content}}</div></div>',
            meta: { 'fa-icon' => 'fa-check-square' },
            title: nil
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
