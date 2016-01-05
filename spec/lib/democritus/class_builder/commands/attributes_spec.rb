require 'spec_helper'
require 'democritus/class_builder/commands'

module Democritus
  class ClassBuilder
    RSpec.describe Commands::Attributes do
      let(:attribute_class) do
        Democritus.build do |builder|
          builder.attributes do
            attribute(:name)
            attribute(:coolness_factor)
          end
        end
      end
      subject { attribute_class.new(name: 'Jeremy') }
      it 'will expose a reader method for the named attribute' do
        expect(subject.name).to eq('Jeremy')
      end
      it 'will default to nil any unset attributes' do
        expect(subject.coolness_factor).to be_nil
      end
    end
  end
end
