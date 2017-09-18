require 'redcarpet'
require 'sanitize'

module Curate
  module TextFormatter
    module_function
    def call(text: nil, block: false, title: false)
      return if text.nil?
      if title
        markdown = title_renderer
      elsif block
        markdown = block_renderer
      else
        markdown = inline_renderer
      end
      html = markdown.render(text)
      Sanitize.fragment(html, Sanitize::Config::RELAXED)
    end

    def title_renderer
      TitleRenderer.new
    end

    def block_renderer
      Redcarpet::Markdown.new(BlockTextRenderer, autolink: true)
    end

    def inline_renderer
      Redcarpet::Markdown.new(InlineTextRenderer, autolink: true)
    end

    class TitleRenderer
      ITALICS_REGEXP = /[_\*]([^[\*_]]+)[_\*]/.freeze
      BOLD_REGEXP = /[_\*]{2}([^[\*_]]+)[_\*]{2}/.freeze
      def render(text)
        text.gsub(BOLD_REGEXP, '<strong>\1</strong>').gsub(ITALICS_REGEXP, '<em>\1</em>').strip
      end
    end

    class BlockTextRenderer < Redcarpet::Render::HTML
      include Redcarpet::Render::SmartyPants
    end

    class InlineTextRenderer < Redcarpet::Render::HTML
      include Redcarpet::Render::SmartyPants

      def list(code, language)
        nil
      end
    end

  end
end
