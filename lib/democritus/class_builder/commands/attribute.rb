require 'democritus/class_builder/command'

module Democritus
  class ClassBuilder
    module Commands
      # Command to assign an attribute to the given built class.
      class Attribute < ::Democritus::ClassBuilder::Command
        # @param builder [#defer, Democritus::ClassBuilder]
        # @param name [#to_sym] The name of the attribute
        # @param options [Hash] The configuration options of the attribute
        def initialize(name:, **options)
          self.builder = options.fetch(:builder)
          self.name = name
          self.options = options
        end

        attr_reader :name
        attr_reader :options

        # Generate the code for the attribute
        #
        # @return void
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

        attr_writer :options

        def name=(input)
          @name = input.to_sym
        end
      end
    end
  end
end
