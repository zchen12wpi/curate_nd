require 'redcarpet'
require 'sanitize'

module Curate
  module TextFormatter
    module_function
    def call(text: nil, block: false)
      return if text.nil?
      if block
        markdown = block_renderer
      else
        markdown = inline_renderer
      end
      html = markdown.render(text)
      Sanitize.fragment(html, Sanitize::Config::RELAXED)
    end

    def block_renderer
      Redcarpet::Markdown.new(BlockTextRenderer, autolink: true)
    end

    def inline_renderer
      Redcarpet::Markdown.new(InlineTextRenderer, autolink: true)
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
