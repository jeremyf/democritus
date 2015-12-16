require "democritus/version"
require 'democritus/class_builder'

module Democritus
  # @api public
  #
  # Responsible for building a class based on atomic components.
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
