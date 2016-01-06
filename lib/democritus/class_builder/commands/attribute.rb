require 'democritus/class_builder/command'

module Democritus
  class ClassBuilder
    module Commands
      # Command to assign an attribute to the given built class.
      class Attribute < ::Democritus::ClassBuilder::Command
        def initialize(name:, builder:, **options)
          self.builder = builder
          self.name = name
          self.options = options
        end

        attr_reader :name, :options

        # :reek:NestedIterators: { exclude: [ 'Democritus::ClassBuilder::Commands::Attribute#call' ] }
        def call
          defer do |subject|
            subject.module_exec(@name) do |name|
              attr_reader name
              private
              attr_writer name
            end
          end
        end

        private

        attr_writer :name, :options
      end
    end
  end
end
