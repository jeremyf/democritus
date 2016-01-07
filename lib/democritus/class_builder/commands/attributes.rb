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

        def attribute(name:, **options)
          attribute_names << name.to_sym
          builder.attribute(name: name.to_sym, **options)
        end

        private

        attr_accessor :additional_configuration, :attribute_names
      end
    end
  end
end
