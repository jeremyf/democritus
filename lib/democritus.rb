require "democritus/version"
require 'democritus/class_builder'

module Democritus
  def self.build
    builder = ClassBuilder.new
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
