require 'json'
module Democritus
  # Responsible for building a class based on the given JSON document.
  #
  # Note the following structure:
  #
  # ```json
  # { "#command_name": { "keyword_param_one": "param_value", "#nested_command_name": { "nested_keyword_param": "nested_param_value"} } }
  # ```
  #
  # Commands that are called against the builder are Hash keys that start with '#'. Keywords are command parameters that
  # do not start with '#'.
  #
  # @note This is a class with a greater "reek" than I would like. However, it
  #   is parsing JSON and loading that into ruby; Its complicated. So I'm
  #   willing to accept and assume responsibility for this code "reek".
  #
  # @see ./spec/lib/democritus/from_json_class_builder_spec.rb
  # @see Democritus::ClassBuilder::Commands
  class FromJsonClassBuilder
    # @api public
    #
    # @param json_document [String] A JSON document
    def initialize(json_document)
      self.data = json_document
    end

    # @api public
    def generate_class
      keywords, nested_commands = extract_keywords_and_nested_commands(node: data)
      class_builder = ClassBuilder.new(**keywords)
      build(node: nested_commands, class_builder: class_builder)
      class_builder.generate_class
    end

    private

    # :reek:NestedIterators: { exclude: [ 'Democritus::FromJsonClassBuilder#build' ] }
    def build(node:, class_builder:)
      json_class_builder = self # establishing local binding
      each_command(node: node) do |command_name, keywords, nested_commands|
        class_builder.public_send(command_name, **keywords) do |nested_builder|
          json_class_builder.send(:build, node: nested_commands, class_builder: nested_builder)
        end
      end
    end

    # :reek:NestedIterators: { exclude: [ 'Democritus::FromJsonClassBuilder#each_command' ] }
    # :reek:FeatureEnvy: { exclude: [ 'Democritus::FromJsonClassBuilder#each_command' ] }
    def each_command(node:)
      node.each_pair do |command_name, nested_nodes|
        nested_nodes = [nested_nodes] unless nested_nodes.is_a?(Array)
        nested_nodes.each do |nested_node|
          keywords, nested_commands = extract_keywords_and_nested_commands(node: nested_node)
          yield(command_name, keywords, nested_commands)
        end
      end
    end

    KEY_IS_COMMAND_REGEXP = /\A\#(.+)$/.freeze

    # rubocop:disable MethodLength
    # :reek:TooManyStatements: { exclude: [ 'Democritus::FromJsonClassBuilder#extract_keywords_and_nested_commands' ] }
    # :reek:UtilityFunction: { exclude: [ 'Democritus::FromJsonClassBuilder#extract_keywords_and_nested_commands' ] }
    def extract_keywords_and_nested_commands(node:)
      keywords = {}
      options = {}
      node.each_pair do |key, value|
        match_data = KEY_IS_COMMAND_REGEXP.match(key)
        if match_data
          options[match_data[1].to_sym] = value
        else
          keywords[key.to_sym] = value
        end
      end
      return [keywords, options]
    end
    # rubocop:enable MethodLength

    attr_reader :data

    def data=(json_document)
      @data = JSON.parse(json_document)
    end
  end
end
