module Democritus
  class ClassBuilder

    def initialize
      self.customization_module = Module.new
    end

    attr_accessor :customization_module
    private :customization_module=

    # @api public
    #
    # Responsible for executing the customization block against the
    # customization module with the scope of this builder class.
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

    private

    def method_missing(method_name, *args, &block)
      command_name = command_name_for_method(method_name)
      if Commands.const_defined?(command_name)
        command_class = Commands.const_get(command_name)
        command_class.new(self, *args, &block).call
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      respond_to_definition(method_name, include_private, :respond_to_missing?)
    end

    def respond_to_definition(method_name, include_private, respond_to_method_name)
      command_name = command_name_for_method(method_name)
      Commands.const_defined?(command_name)
    end

    def command_name_for_method(method_name)
      method_name.to_s.gsub(/(?:^|_)([a-z])/) { Regexp.last_match[1].upcase }
    end
  end
end
