require "democritus/version"
require 'democritus/class_builder'
require 'democritus/class_builder/commands'
require 'democritus/from_json_class_builder'

# Compose objects by leveraging a DSL for class creation.
# Yes, we can write code that conforms to interfaces, but in my experience, as the Ruby object ecosystem has grown, so too has the needs
# for understanding the galaxy of objects.
module Democritus
  # @api public
  # @since 0.1.0
  #
  # Responsible for building a class based on atomic components.
  #
  # @yield [Democritus::ClassBuilder] a builder object to provide additional command style customizations
  # @return Class
  #
  # @example
  #   NamedPerson = Democritus.build do |builder|
  #     builder.attributes do
  #       attribute(name: :given_name)
  #       attribute(name: :surname)
  #     end
  #   end
  #   NamedPerson.new(given_name: 'Farrokh', surname: 'Bulsara')
  #
  # @see Demcoritus::ClassBuilder
  def self.build(&configuration_block)
    builder = ClassBuilder.new
    builder.customize(&configuration_block)
    builder.generate_class
  end

  # @api public
  # @since 0.2.0
  #
  # Responsible for building a class based on the given JSON object.
  #
  # @param [String] A "well-formed" JSON document
  # @return Class
  #
  #   NamedPerson = Democritus.build_from_json(%{
  #     "#attributes": {
  #       "#attribute": [{ "name": "given_name" }, { "name": "surname"}]
  #     }
  #   })
  #   NamedPerson.new(given_name: 'Farrokh', surname: 'Bulsara')
  #
  # @see Demcoritus::FromJsonClassBuilder for details on "well-formed"
  def self.build_from_json(json)
    builder = FromJsonClassBuilder.new(json)
    builder.generate_class
  end

  # An empty module intended to be exposed for is_a? comparisons (and ==)
  #
  # @example
  #   AnotherClass = Democritus.build
  #   assert_equal true, AnotherClass.new.is_a?(Democritus::DemocritusObjectTag)
  module DemocritusObjectTag
  end
end
