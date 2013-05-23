require 'active_attr'
module ActiveFedora
  module DelegateAttributes
    extend ActiveSupport::Concern

    included do
      class_attribute :delegate_attributes, instance_writer: false, instance_reader: false
    end

    module ClassMethods
      def attribute(attribute_name, options ={})
        options.symbolize_keys!
        options[:multiple] = true unless options.key?(:multiple)
        self.delegate_attributes ||= {}
        self.delegate_attributes[attribute_name.to_sym] = options

        if validate_option = options.delete(:validates)
          validates(attribute_name, validate_option)
        end
        options[:unique] = !options[:multiple]
        delegate_to(options[:datastream], [attribute_name], options)
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
      delegate_attributes_map { |name| _attribute_default name }
    end

    # Applies attribute default values
    def initialize(*)
      super
      apply_defaults
    end

    private

    # Calculates an attribute default
    #
    # @private
    # @since 0.5.0
    def _attribute_default(attribute_name)
      default = self.class.delegate_attributes[attribute_name][:default]

      case
      when default.respond_to?(:call) then instance_exec(&default)
      when default.duplicable? then default.dup
      else default
      end
    end

    def delegate_attributes_map
      Hash[ self.class.delegate_attributes.map { |name, options| [name, yield(name)] } ]
    end

  end
end