require 'spec_helper'
require 'democritus/class_builder'

RSpec.describe Democritus::ClassBuilder do
  subject { described_class.new }

  its(:generate_class) { should be_a(Class) }
  its(:customization_module) { should be_a(Module) }

  context '#customize' do
    it 'will return nil if no block is passed' do
      expect(subject.customize).to be_nil
    end

    it 'will add instance methods defined in the block to the instance methods of the customization module' do
      expect { subject.customize { |builder| def hello_world; end } }.
        to change { subject.customization_module.instance_methods.include?(:hello_world) }.from(false).to(true)
      expect(subject.customization_module.methods).to_not include(:hello_world)
    end

    it 'will add class methods defined in the block to the class methods of the customization module' do
      expect { subject.customize { |builder| def self.hello_world; end } }.
        to change { subject.customization_module.methods.include?(:hello_world) }.from(false).to(true)
      expect(subject.customization_module.instance_methods).to_not include(:hello_world)
    end
  end
end
