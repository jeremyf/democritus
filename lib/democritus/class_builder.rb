module Democritus
  class ClassBuilder

    def initialize
      self.customization_module = Module.new
    end

    attr_accessor :customization_module
    private :customization_module=

    # @api public
    #
    # Responsible for capturing the customization block and applying executing
    # it for configuration of the given class.
    def customize(&customization_block)
      return unless customization_block
      customization_module.module_exec(self, &customization_block)
    end

    # @api public
    def generate_class
      Class.new do
        include DemocritusObjectTag
      end
    end
  end
end
