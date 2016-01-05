require 'spec_helper'
require 'democritus/class_builder/commands/attribute'

module Democritus
  class ClassBuilder
    RSpec.describe Commands::Attribute do
      let(:attribute_class) do
        Democritus.build do |builder|
          builder.attribute(:name)
          def initialize(name:)
            self.name = name
          end
        end
      end
      subject { attribute_class.new(name: 'Jeremy') }
      it 'will expose a reader method for the named attribute' do
        expect(subject.name).to eq('Jeremy')
      end
    end
  end
end
