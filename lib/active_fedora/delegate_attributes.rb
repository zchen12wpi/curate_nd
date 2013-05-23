require 'active_attr'
module ActiveFedora
  module DelegateAttributes
    class Attribute

      attr_reader :name, :datastream, :validates
      delegate :[], to: :options

      def initialize(name, options = {})
        @options = options.symbolize_keys
        @name = name
        @options[:multiple] = true unless @options.key?(:multiple)
      end

      def options_for_delegation
        {
          to: options[:datastream],
          at: options[:at],
          unique: !options[:multiple]
        }
      end

      def options_for_validation
        options[:validates] || {}
      end

      def default(context)
        this_default = options[:default]
        case
        when this_default.respond_to?(:call) then context.instance_exec(&this_default)
        when this_default.duplicable? then this_default.dup
        else this_default
        end
      end

      private

      def options
        @options
      end

    end

    extend ActiveSupport::Concern
    included do
      class_attribute :delegate_attributes, instance_writer: false, instance_reader: false
    end

    module ClassMethods
      def attribute(attribute_name, options ={})
        attribute = Attribute.new(attribute_name, options)

        self.delegate_attributes ||= []
        self.delegate_attributes += [attribute]

        validates(attribute.name, attribute.options_for_validation) if attribute.options_for_validation.present?
        delegate(attribute.name, attribute.options_for_delegation)
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

    # Calculates the attribute defaults from the attribute definitions
    #
    # @return [Hash{String => Object}] the attribute defaults
    def attribute_defaults
      self.class.delegate_attributes.collect { |attribute| [attribute.name, attribute.default(self)] }
    end

    # Applies attribute default values
    def initialize(*)
      super
      apply_defaults
    end

  end
end