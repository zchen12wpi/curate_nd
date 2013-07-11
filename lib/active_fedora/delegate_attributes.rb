require 'active_attr'
require File.expand_path('../delegate_attributes/attribute', __FILE__)
module ActiveFedora
  module DelegateAttributes
    extend ActiveSupport::Concern
    included do
      class_attribute :delegate_attributes, instance_writer: false, instance_reader: false
    end

    class AttributeCollection < DelegateClass(HashWithIndifferentAccess)
      attr_accessor :context
      def initialize(context)
        @context = context
        super(HashWithIndifferentAccess.new)
      end

      def register(attribute)
        self[attribute.name] = attribute
      end

      def editable_attributes
        @editable_attributes ||= each_with_object([]) {|(name, attribute),m|
          m << attribute if attribute.editable?
        }
      end

      def displayable_attributes
        @displayable_attributes ||= each_with_object([]) {|(name, attribute),m|
          m << attribute if attribute.displayable?
        }
      end

      # Calculates the attribute defaults from the attribute definitions
      #
      # @return [Hash{String => Object}] the attribute defaults
      def attribute_defaults
        collect { |name, attribute| [name, attribute.default(self)] }
      end

      def attribute_config(name)
        fetch(name)
      end

      def input_options_for(attribute_name, override_options)
        attribute_config(attribute_name).options_for_input(override_options)
      rescue KeyError
        override_options
      end

      def label_for(name)
        attribute_config(name).label
      rescue KeyError
        name.to_s.titleize
      end
    end


    delegate :attribute_defaults, to: :delegate_attribute_registry
    delegate :attribute_config, to: :delegate_attribute_registry
    delegate :input_options_for, to: :delegate_attribute_registry
    delegate :label_for, to: :delegate_attribute_registry
    delegate :editable_attributes, to: :delegate_attribute_registry
    delegate :displayable_attributes, to: :delegate_attribute_registry

    def delegate_attribute_registry
      self.class.delegate_attributes
    end
    private :delegate_attribute_registry

    module ClassMethods
      def attribute(attribute_name, options ={})
        attribute = Attribute.new(attribute_name, options)

        self.delegate_attributes ||= AttributeCollection.new(self)
        self.delegate_attributes.register(attribute)

        attribute.with_validation_options do |name, opts|
          validates(name, opts)
        end

        attribute.with_accession_options do |name, opts|
          attr_accessor name
        end

        attribute.with_delegation_options do |name, opts|
          delegate(name, opts)
        end

        attribute.wrap_writer_method(self)
        attribute.wrap_reader_method(self)
      end
    end


    # Applies the attribute defaults
    #
    # Applies all the default values to any attributes not yet set, avoiding
    # any attribute setter logic, such as dirty tracking.
    #
    # @param [Hash{String => Object}, #each] defaults The defaults to apply
    def apply_defaults(defaults=attribute_defaults)
      defaults.each do |name, value|
        unless value.nil?
          send("#{name}=", value) unless send("#{name}").present?
        end
      end
    end

    # Applies attribute default values
    def initialize(*)
      super
      apply_defaults
    end

  end
end
