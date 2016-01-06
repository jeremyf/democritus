require 'spec_helper'
require 'democritus/class_builder'

module Democritus
  class ClassBuilder
    module Commands
      class TestCommand
      end
    end
    module AlternateCommands
      class AlternateTestCommand
      end
    end
  end

  RSpec.describe ClassBuilder do
    subject { described_class.new }

    its(:generate_class) { should be_a(Class) }
    its(:customization_module) { should be_a(Module) }

    context '.constants' do
      subject { described_class.new.generate_class.constants }
      it { should include(:GeneratedMethods) }
    end

    context '.command_name_for_method' do
      it 'converts single word method' do
        expect(described_class.command_name_for_method(:test)).to eq('Test')
      end
      it 'converts multi-word method' do
        expect(described_class.command_name_for_method(:test_something)).to eq('TestSomething')
      end
    end

    it 'responds to commands defined in ClassBuilder::Commands' do
      expect(subject).to respond_to(:test_command)
    end

    it 'translates method calls into namespaced command invocations including arguments' do
      test_command = double
      expect(described_class::AlternateCommands::AlternateTestCommand).to receive(:new).
        with('foo', 42, builder: subject).
        and_return(test_command)
      expect(test_command).to receive(:call).and_return('COMMAND RESULT')
      expect(subject.alternate_test_command('foo', 42, command_namespace: described_class::AlternateCommands)).to eq('COMMAND RESULT')
    end

    it 'translates method calls into command invocations including arguments' do
      test_command = double
      expect(described_class::Commands::TestCommand).to receive(:new).
        with('foo', 42, builder: subject).
        and_return(test_command)
      expect(test_command).to receive(:call).and_return('COMMAND RESULT')
      expect(subject.test_command('foo', 42)).to eq('COMMAND RESULT')
    end

    it 'handles missing non-command missing methods normally' do
      expect(subject).not_to respond_to(:nonexistant_method)
      expect { subject.nonexistent_method }.to raise_error(NoMethodError)
    end

    context '#customize' do
      it 'will return nil if no block is passed' do
        expect(subject.customize).to be_nil
      end

      it 'will return nil if a block is passed' do
        expect(subject.customize { |*| def hello_world; end }).to be_nil
      end

      it 'will add instance methods defined in the block to the instance methods of the customization module' do
        expect { subject.customize { |*| def hello_world; end } }.
          to change { subject.send(:customization_module).instance_methods.include?(:hello_world) }.from(false).to(true)
        expect(subject.send(:customization_module).methods).to_not include(:hello_world)
      end

      it 'will add class methods defined in the block to the class methods of the customization module' do
        expect { subject.customize { |*| def self.hello_world; end } }.
          to change { subject.send(:customization_module).methods.include?(:hello_world) }.from(false).to(true)
        expect(subject.send(:customization_module).instance_methods).to_not include(:hello_world)
      end
    end
  end
end
