module Democritus
  # Responsible for building a class based on the customization's applied
  # through the #customize method.
  #
  # @see ./spec/lib/democritus/class_builder_spec.rb
  class ClassBuilder
    def initialize
      self.customization_module = Module.new
    end

    private

    attr_accessor :customization_module

    public

    # @api public
    #
    # Responsible for executing the customization block against the
    # customization module with the scope of this builder class.
    public def customize(&customization_block)
      return unless customization_block
      customization_module.module_exec(self, &customization_block)
    end

    # @api public
    #
    # Responsible for generating a Class object based on the customizations
    # applied via a customize block.
    #
    # @return Class object
    public def generate_class
      Class.new do
        include DemocritusObjectTag
      end
    end

    private def method_missing(method_name, *args, &block)
      command_name = self.class.command_name_for_method(method_name)
      if Commands.const_defined?(command_name)
        command_class = Commands.const_get(command_name)
        command_class.new(self, *args, &block).call
      else
        super
      end
    end

    private def respond_to_missing?(method_name, *args)
      respond_to_definition(method_name, :respond_to_missing?, *args)
    end

    private def respond_to_definition(method_name, *)
      command_name = self.class.command_name_for_method(method_name)
      Commands.const_defined?(command_name)
    end

    def self.command_name_for_method(method_name)
      method_name.to_s.gsub(/(?:^|_)([a-z])/) { Regexp.last_match[1].upcase }
    end
  end
end
