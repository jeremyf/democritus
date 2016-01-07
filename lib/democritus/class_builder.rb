module Democritus
  # Responsible for building a class based on the customization's applied
  # through the #customize method.
  #
  # @see ./spec/lib/democritus/class_builder_spec.rb
  #
  # :reek:UnusedPrivateMethod: { exclude: [ !ruby/regexp /(method_missing|respond_to_missing)/ ] }
  class ClassBuilder
    # @param command_namespaces [Array<Module>] the sequential list of namespaces you want to check for each registered command.
    def initialize(command_namespaces: default_command_namespaces)
      self.customization_module = Module.new
      self.generation_module = Module.new
      self.class_operations = []
      self.instance_operations = []
      self.command_namespaces = command_namespaces
    end

    private

    # The module that receives customized method definitions.
    #
    # @example
    #   Democritus.build do |builder|
    #     builder.a_command
    #     def a_customization
    #     end
    #   end
    #
    # The above #a_customization method is captured in the customization_module and applied as an instance method
    # to the generated class.
    attr_accessor :customization_module
    attr_accessor :generation_module

    # Command operations to be applied as class methods of the generated_class.
    attr_accessor :class_operations

    # The default namespaces in which Democritus will look up commands.
    def default_command_namespaces
      [Democritus::ClassBuilder::Commands]
    end

    # The command namespaces that you want to use. Note, order is important
    attr_reader :command_namespaces

    def command_namespaces=(input)
      @command_namespaces = Array(input)
    end

    # Command operations to be applied as instance methods of the generated_class.
    attr_accessor :instance_operations

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
    #
    # rubocop:disable MethodLength
    # :reek:TooManyStatements: { exclude: [ 'Democritus::ClassBuilder#generate_class' ] }
    def generate_class
      generation_mod = generation_module # get a local binding
      customization_mod = customization_module # get a local binding
      apply_operations(instance_operations, generation_mod)
      generated_class = Class.new do
        const_set :GeneratedMethods, generation_mod
        const_set :Customizations, customization_mod
        include DemocritusObjectTag
        include generation_mod
        include customization_mod
      end
      generated_class
    end
    # rubocop:enable MethodLength

    # @api public
    #
    # When configuring the class that is being built, we don't want to apply all of the modifications at once, instead allowing them
    # to be applied in a specified order.
    #
    # @param [Hash] options
    # @option options [Boolean] :prepend Is there something about this deferred_operation that should happen first?
    # @param defered_operation [#call]
    #
    # @return void
    def defer(**options, &deferred_operation)
      if options[:prepend]
        instance_operations.unshift(deferred_operation)
      else
        instance_operations << deferred_operation
      end
    end

    private

    # :reek:UtilityFunction: { exclude: [ 'Democritus::ClassBuilder#apply_operations' ] }
    def apply_operations(operations, module_or_class)
      operations.each do |operation|
        operation.call(module_or_class)
      end
    end

    # @!group Method Missing

    private

    # @api public
    def method_missing(method_name, *args, **kargs, &block)
      command_name = self.class.command_name_for_method(method_name)
      command_namespace = command_namespace_for(command_name)
      if command_namespace
        command_class = command_namespace.const_get(command_name)
        command_class.new(*args, **kargs.merge(builder: self), &block).call
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
      command_namespace_for(command_name)
    end

    # @api private
    def command_namespace_for(command_name)
      command_namespaces.detect { |cs| cs.const_defined?(command_name) }
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
