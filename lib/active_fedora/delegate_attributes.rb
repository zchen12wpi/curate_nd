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

      def create_writer(klass)
        if writer = options[:writer]
          writer_method_name = "#{name}="
          writer_instance =  klass.instance_method(writer_method_name)
          if writer.respond_to?(:call)
            if multiple?
              klass.send(:define_method, writer_method_name) do |values|
                writer_instance.bind(self).call(values.collect{|v| writer.call(v)})
              end
            else
              klass.send(:define_method, writer_method_name) do |value|
                writer_instance.bind(self).call(writer.call(value))
              end
            end
          else
            if multiple?
              klass.send(:define_method, writer_method_name) do |values|
                writer_instance.bind(self).call(values.collect{|value| send(writer,value)})
              end
            else
              klass.send(:define_method, writer_method_name) do |value|
                writer_instance.bind(self).call(send(writer, value))
              end
            end
          end
        end
      end

      def create_reader(klass)
        if reader = options[:reader]
          reader_method_name = "#{name}"
          reader_instance =  klass.instance_method(reader_method_name)
          if reader.respond_to?(:call)
            if multiple?
              klass.send(:define_method, reader_method_name) do
                reader_instance.bind(self).call.collect{|value| reader.call(value)}
              end
            else
              klass.send(:define_method, reader_method_name) do
                reader.call(reader_instance.bind(self).call)
              end
            end
          else
            if multiple?
              klass.send(:define_method, reader_method_name) do
                reader_instance.bind(self).call.collect{|value| send(reader, value)}
              end
            else
              klass.send(:define_method, reader_method_name) do
                send(reader, reader_instance.bind(self).call)
              end
            end
          end
        end
      end

      private

        def multiple?
          options[:multiple]
        end

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

        self.delegate_attributes ||= {}
        self.delegate_attributes[attribute.name] = attribute

        validates(attribute.name, attribute.options_for_validation) if attribute.options_for_validation.present?
        delegate(attribute.name, attribute.options_for_delegation)
        attribute.create_writer(self)
        attribute.create_reader(self)
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
      self.class.delegate_attributes.collect { |name, attribute| [name, attribute.default(self)] }
    end

    # Applies attribute default values
    def initialize(*)
      super
      apply_defaults
    end

  end
end
