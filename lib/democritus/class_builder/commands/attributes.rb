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
        # @param pre_deferment_operation [Proc] A means to nest additional operations
        def initialize(builder:, &pre_deferment_operation)
          self.builder = builder
          self.pre_deferment_operation = pre_deferment_operation
          self.attribute_names = []
        end

        # @api public
        #
        # Method that generates the behavior for the Attributes command
        #
        # @return void
        # @see Democritus::ClassBuilder#defer
        def call
          # In order to register any nested attributes, the pre_deferment_operation must be performed
          # outside of the defer method call. If it were done inside the defer block, then the pre_deferment_operation
          # might get lost.
          execute_pre_deferment_operation
          defer { |subject| configure(subject: subject) }
        end

        private

        def execute_pre_deferment_operation
          return unless pre_deferment_operation.respond_to?(:call)
          # It may seem a little odd to yield self via an instance_exec, however in some cases I need a
          # receiver for messages (i.e. FromJsonClassBuilder)
          instance_exec(self, &pre_deferment_operation)
        end

        # :reek:NestedIterators: { exclude: [ 'Democritus::ClassBuilder::Commands::Attributes#configure' ] }
        def configure(subject:)
          subject.module_exec(@attribute_names) do |attribute_names|
            define_method(:initialize) do |**attributes|
              attribute_names.each do |attribute_name|
                send("#{attribute_name}=", attributes.fetch(attribute_name.to_sym, nil))
              end
            end
          end
        end

        public

        # @!group Commands Available Within the pre_deferment_operation

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

        # @!endgroup

        private

        attr_accessor :pre_deferment_operation

        # [Array] of attribute names that have been generated
        attr_accessor :attribute_names
      end
    end
  end
end
