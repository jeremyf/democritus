require 'democritus/class_builder/command'

module Democritus
  class ClassBuilder
    module Commands
      # Command to assign attributes as part of the initialize method.
      #
      # @example
      #   Democritus::ClassBuilder::Commands::Attributes.new(builder: a_builder) do
      #     attribute(:name)
      #     attribute(:coolness_factor)
      #   end
      class Attributes < ::Democritus::ClassBuilder::Command
        # @param builder [Democritus::ClassBuilder]
        # @param additional_configuration [Proc] A means to nest additional configuration
        def initialize(builder:, &additional_configuration)
          self.builder = builder
          self.additional_configuration = additional_configuration
          self.attribute_names = []
        end

        # :reek:NestedIterators: { exclude: [ 'Democritus::ClassBuilder::Commands::Attributes#call' ] }
        # :reek:TooManyStatements: { exclude: [ 'Democritus::ClassBuilder::Commands::Attributes#call' ] }
        def call
          # It may seem a little odd to yield self via an instance_exec, however in some cases I need a
          # receiver for messages (i.e. FromJsonClassBuilder)
          instance_exec(self, &additional_configuration) if additional_configuration.respond_to?(:call)
          defer do |subject|
            subject.module_exec(@attribute_names) do |attribute_names|
              define_method(:initialize) do |**attributes|
                attribute_names.each do |attribute_name|
                  send("#{attribute_name}=", attributes.fetch(attribute_name.to_sym, nil))
                end
              end
            end
          end
        end

        # @api public
        #
        # Exposes a mechanism for assigning individual attributes as part of the #attributes command.
        #
        # @param name [#to_sym] the name of the attribute
        # @param options [Hash] additional options passed to the builder#attribute command
        #
        # @see Democritus::ClassBuilder::Commands::Attribute
        # @see Democritus::ClassBuilder
        def attribute(name:, **options)
          name = name.to_sym
          attribute_names << name
          builder.attribute(name: name, **options)
        end

        private

        attr_accessor :additional_configuration

        # [Array] of attribute names that have been generated
        attr_accessor :attribute_names
      end
    end
  end
end
