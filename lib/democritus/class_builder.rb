module Democritus
  class ClassBuilder
    # @api public
    def generate_class
      Class.new do
        include DemocritusObjectTag
      end
    end

    # @api public
    #
    # Responsible for capturing the customization block and applying executing
    # it for configuration of the given class.
    def customize(&customization_block)
      return unless customization_block
    end
  end
end
