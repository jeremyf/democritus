require "democritus/version"
require 'democritus/class_builder'

# Compose objects by leveraging a DSL for class creation.
# Yes, we can write code that conforms to interfaces, but in my experience, as the Ruby object ecosystem has grown, so too has the needs
# for understanding the galaxy of objects.
module Democritus
  # @api public
  #
  # Responsible for building a class based on atomic components.
  #
  # @yield [Democritus::ClassBuilder] Gives a builder to provide additional command style customizations
  # @return Class
  def self.build(&configuration_block)
    builder = ClassBuilder.new
    builder.customize(&configuration_block)
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
