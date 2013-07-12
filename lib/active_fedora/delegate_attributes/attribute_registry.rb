module ActiveFedora
  module DelegateAttributes
    class AttributeRegistry < DelegateClass(HashWithIndifferentAccess)
      attr_accessor :context
      def initialize(context)
        @context = context
        super(HashWithIndifferentAccess.new)
      end

      def register(attribute_name, options)
        attribute = Attribute.new(attribute_name, options)
        self[attribute.name] = attribute
        yield(attribute) if block_given?
        attribute
      end

      def editable_attributes
        @editable_attributes ||= each_with_object([]) {|(name, attribute), m|
          m << attribute if attribute.editable?
          m
        }
      end

      def displayable_attributes
        @displayable_attributes ||= each_with_object([]) {|(name, attribute),m|
          m << attribute if attribute.displayable?
          m
        }
      end

      # Calculates the attribute defaults from the attribute definitions
      #
      # @return [Hash{String => Object}] the attribute defaults
      def attribute_defaults
        collect { |name, attribute| [name, attribute.default(context)] }
      end

      def input_options_for(attribute_name, override_options = {})
        fetch(attribute_name).options_for_input(override_options)
      rescue KeyError
        override_options
      end

      def label_for(name)
        fetch(name).label
      rescue KeyError
        name.to_s.titleize
      end
    end

  end
end
