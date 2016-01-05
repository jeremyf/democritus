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
    # customization module with the builder class as a parameter.
    #
    # @yield [Democritus::ClassBuilder] the means to build your custom class.
    #
    # @example
    #   ClassBuilder.new.customize do |builder|
    #     builder.command('paramter')
    #     def to_s; 'parameter'; end
    #   end
    #
    # @return nil
    # @see ./spec/lib/democritus/class_builder_spec.rb
    def customize(&customization_block)
      return unless customization_block
      customization_module.module_exec(self, &customization_block)
      return nil
    end

    # @api public
    #
    # Responsible for generating a Class object based on the customizations
    # applied via a customize block.
    #
    # @example
    #   dynamic_class = Democritus::ClassBuilder.new.generate_class
    #   an_instance_of_the_dynamic_class = dynamic_class.new
    #
    # @return Class object
    def generate_class
      Class.new do
        include DemocritusObjectTag
      end
    end

    # @!group Method Missing
    private

    # @api public
    def method_missing(method_name, *args, command_namespace: Commands, &block)
      command_name = self.class.command_name_for_method(method_name)
      if command_namespace.const_defined?(command_name)
        command_class = command_namespace.const_get(command_name)
        command_class.new(*args, builder: self, &block).call
      else
        super
      end
    end

    # @api public
    def respond_to_missing?(method_name, *args)
      respond_to_definition(method_name, :respond_to_missing?, *args)
    end

    # @api public
    def respond_to_definition(method_name, *)
      command_name = self.class.command_name_for_method(method_name)
      Commands.const_defined?(command_name)
    end
    # @!endgroup

    class << self
      # @api public
      #
      # Convert the given :method_name into a "constantized" method name.
      #
      # @example
      #   Democritus::ClassBuilder.command_name_for_method(:test_command) == 'TestCommand'
      #
      # @param method_name [#to_s]
      # @return String
      def command_name_for_method(method_name)
        method_name.to_s.gsub(/(?:^|_)([a-z])/) { Regexp.last_match[1].upcase }
      end
    end
  end
end
