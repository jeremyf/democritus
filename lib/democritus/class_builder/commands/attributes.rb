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
          instance_exec(builder, &additional_configuration)
          defer do |subject|
            subject.module_exec(@attribute_names) do |attribute_names|
              define_method(:initialize) do |**attributes|
                attribute_names.each do |attribute_name|
                  send("#{attribute_name}=", attributes.fetch(attribute_name, nil))
                end
              end
            end
          end
        end

        private

        def attribute(attribute_name, **options)
          attribute_names << attribute_name
          builder.attribute(name: attribute_name, **options)
        end

        attr_accessor :additional_configuration, :attribute_names
      end
    end
  end
end
