module AccordionBuilderHelper
  def accordion(opts = {})
    opts[:accordion_id] ||= 'panel-group'
    opts[:open] = true unless opts.has_key?(:open)
    builder = AccordionBuilder.new(opts, self)
    content_tag(:div, :class => 'panel-group', :id => opts[:accordion_id]) do
      yield builder
    end
  end

  class AccordionBuilder

    attr_reader :parent, :opts, :fieldset_rendered_counter
    delegate :capture, :content_tag, :raw, :link_to, :to => :parent

    def initialize(opts, parent)
      @fieldset_rendered_counter = 0
      @parent = parent
      @opts = opts
    end

    def pane(title, fieldset_opts = {}, &block)
      content_tag(:div, :class => 'panel panel-default') do
        heading(title, fieldset_opts) + body(title, fieldset_opts, &block)
      end
    end

    private

    def heading(title, fieldset_opts)
      content_tag(:div, :class => 'panel-heading') do
        content_tag(:h3) do
          link_to(
            title,
            "##{fieldset_id_for_index(fieldset_rendered_counter)}",
            :class => 'panel-collapse', :'data-toggle' => 'collapse',
            :'data-parent' => "##{opts[:accordion_id]}"
          )
        end
      end
    end

    def body(title, fieldset_opts, &block)
      content_tag(:div, :class => "panel-collapse in", :id => fieldset_id_for_index(fieldset_rendered_counter)) do
        content_tag(:div, :class => 'panel-body') do
          content_tag(:div) do
            capture(&block)
          end + pane_actions(fieldset_opts)
        end
      end
    end

    def pane_actions(fieldset_opts)
      actions = ''
      if fieldset_opts[:open_next]
        actions = content_tag(:div, :class => 'row') do
          link_to(
            raw('Continue&hellip;'),
            "##{fieldset_id_for_index(fieldset_rendered_counter+1)}",
            :class => 'btn btn-info  pull-right continue',
            :'data-toggle' => 'collapse',
            :'data-target' => "##{fieldset_id_for_index(fieldset_rendered_counter+1)}",
            :'data-parent' => "##{opts[:accordion_id]}"
          )
        end
      end
      fieldset_rendered!
      return actions
    end

    def first_fieldset?
      @fieldset_rendered_counter == 0
    end
    def fieldset_rendered!
      @fieldset_rendered_counter += 1
    end
    def fieldset_id_for_index(i)
      "#{opts[:accordion_id]}-fieldset-#{i}"
    end

  end
end
