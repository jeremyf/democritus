require 'json'
module Democritus
  # Responsible for building a class based on the given JSON document.
  #
  # @note This is a class with a greater "reek" than I would like. However, it
  #   is parsing JSON and loading that into ruby; Its complicated. So I'm
  #   willing to accept and assume responsibility for this code "reek".
  #
  # @see ./spec/lib/democritus/from_json_class_builder_spec.rb
  class FromJsonClassBuilder
    def initialize(json)
      self.data = json
    end

    # @api public
    def generate_class
      keywords, options = extract_keywords_and_options_from(node: data)
      class_builder = ClassBuilder.new(**keywords)
      build(node: options, class_builder: class_builder)
      class_builder.generate_class
    end

    private

    # :reek:NestedIterators: { exclude: [ 'Democritus::FromJsonClassBuilder#build' ] }
    def build(node:, class_builder:)
      json_class_builder = self # establishing local binding
      each_command(node: node) do |command, keywords, nested_node|
        class_builder.public_send(command, **keywords) do |nested_builder|
          json_class_builder.send(:build, node: nested_node, class_builder: nested_builder)
        end
      end
    end

    # :reek:NestedIterators: { exclude: [ 'Democritus::FromJsonClassBuilder#each_command' ] }
    # :reek:FeatureEnvy: { exclude: [ 'Democritus::FromJsonClassBuilder#each_command' ] }
    def each_command(node:)
      node.each_pair do |key, values|
        values = [values] unless values.is_a?(Array)
        values.each do |value|
          keywords, options = extract_keywords_and_options_from(node: value)
          yield(key, keywords, options)
        end
      end
    end

    PARAMETER_KEY_REGEXP = /(\w+):$/.freeze

    # rubocop:disable MethodLength
    # :reek:TooManyStatements: { exclude: [ 'Democritus::FromJsonClassBuilder#extract_keywords_and_options_from' ] }
    # :reek:UtilityFunction: { exclude: [ 'Democritus::FromJsonClassBuilder#extract_keywords_and_options_from' ] }
    def extract_keywords_and_options_from(node:)
      keywords = {}
      options = {}
      node.each_pair do |key, value|
        match_data = PARAMETER_KEY_REGEXP.match(key)
        if match_data
          keywords[match_data[1].to_sym] = value
        else
          options[key] = value
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
