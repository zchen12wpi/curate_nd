# Responsible for converting matching Source URLs to a rendered list
# item with specific callout links and appropriate link texts
class SourceCalloutAttributeRenderer
  DEFAULT_PATTERNS_AND_LABELS = [
    {
      callout_pattern: /\Ahttps?:\/\/undpress\.nd\.edu/,
      callout_text: "Purchase through the University of Notre Dame Press"
    }, {
      callout_pattern: /\Ahttps?:\/\/rbsc\.library\.nd\.edu\/finding_aids\//,
      callout_text: "See the Rare Books and Special Collections page for more details on this record"
    }
  ]

  # @api public
  # @return [String] the rendered list item with possible callout links
  def self.render(options = {})
    new(options).render
  end

  def initialize(options = {})
    @view_context = options.fetch(:view_context)
    @method_name = options.fetch(:method_name)
    @value = options.fetch(:value)
    @block_formatting = options.fetch(:block_formatting)
    @tag = options.fetch(:tag)
    @options = options.fetch(:options)
    extract_callout_text!
  end

  def render
    if callout_text?
      __render_tabular_list_item do
        %(<a href="#{h(value)}" class="callout-link" target="_blank"><span class="callout-text">#{callout_text}</span></a>)
      end
    else
      __render_tabular_list_item
    end
  end

  def callout_text?
    callout_text.present?
  end

  attr_reader :callout_text

  private

  attr_reader :view_context, :method_name, :value, :block_formatting, :tag, :options

  def __render_tabular_list_item(&block)
    view_context.send(:__render_tabular_list_item, method_name, value, block_formatting, tag, options, &block)
  end

  def h(*args)
    view_context.send(:h, *args)
  end

  def extract_callout_text!
    patterns_and_labels.each do |data|
      pattern = data.fetch(:callout_pattern)
      next if value !~ pattern
      text = data.fetch(:callout_text)
      @callout_text = text
      break
    end
  end

  def patterns_and_labels
    @patterns_and_labels ||= begin
      # Using callout_pattern and callout_text for backwards compatability
      custom_pattern = options.fetch(:callout_pattern, nil)
      custom_text = options.fetch(:callout_text, nil)
      if custom_pattern && custom_text
        [{ callout_pattern: custom_pattern, callout_text: custom_text }] + DEFAULT_PATTERNS_AND_LABELS
      else
        DEFAULT_PATTERNS_AND_LABELS
      end
    end
  end
end
