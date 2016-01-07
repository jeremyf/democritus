require 'spec_helper'
require 'democritus/class_builder/commands'

module Democritus
  class ClassBuilder
    RSpec.describe Commands::Attributes do
      context 'feature specification', type: :feature do
        let(:attribute_class) do
          Democritus.build do |builder|
            builder.attributes do
              attribute(name: :name)
              attribute(name: :coolness_factor)
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

      let(:builder) { double('Class Builder', defer: true) }
      let(:configuration) do
        proc do |builder|
          builder.configuration_called!
          attribute(name: 'ketchup')
        end
      end
      subject { described_class.new(builder: builder, &configuration) }

      it 'will execute the configuration block within the context of the Attributes command' do
        expect(subject).to receive(:configuration_called!)
        expect(subject).to receive(:attribute).with(name: 'ketchup')
        subject.call
      end
    end
  end
end
