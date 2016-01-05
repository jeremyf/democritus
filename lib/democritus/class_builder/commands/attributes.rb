require 'democritus/class_builder/command'

module Democritus
  class ClassBuilder
    module Commands
      # Command to assign attributes as part of the initialize method
      class Attributes < ::Democritus::ClassBuilder::Command
        def initialize(builder:, &attribute_configuration_block)
          self.builder = builder
          self.attribute_configuration_block = attribute_configuration_block
          self.attribute_names = []
        end

        # :reek:NestedIterators: { exclude: [ 'Democritus::ClassBuilder::Commands::Attributes#call' ] }
        # :reek:TooManyStatements: { exclude: [ 'Democritus::ClassBuilder::Commands::Attributes#call' ] }
        def call(&block)
          instance_exec(&attribute_configuration_block)
          defer do |subject|
            subject.module_exec(@builder, @attribute_names) do |builder, attribute_names|
              define_method(:initialize) do |**attributes|
                attribute_names.each do |attribute_name|
                  value = attributes.fetch(attribute_name, nil)
                  send("#{attribute_name}=", value)
                end
              end
            end
          end
        end

        private

        def attribute(attribute_name, **options)
          attribute_names << attribute_name
          builder.attribute(attribute_name, **options)
        end

        attr_accessor :attribute_configuration_block, :attribute_names
      end
    end
  end
end
