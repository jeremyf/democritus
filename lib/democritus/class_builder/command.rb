module Democritus
  class ClassBuilder
    # @api public
    #
    # An abstract class useful in composing additional Democritus::Commands
    #
    # The expected interface for a Democritus::Command is as follows:
    #
    # * Its #initialize method must accept a :builder keyword (i.e. `#initialize`)
    # * It responds to #call and #call does not accept any parameters
    class Command
      # @api public
      #
      # @param builder [Democritus::ClassBuilder] The context in which we are leveraging this building command.
      def initialize(*, builder:)
        self.builder = builder
      end

      # @api public
      #
      # @abstract Subclass and override #call to implement
      def call
        fail(NotImplementedError, 'Method #call should be overriden in child classes')
      end

      # @api private
      def defer(options = {}, &block)
        builder.defer(options, &block)
      end

      private

      attr_accessor :builder
    end
  end
end
