require 'spec_helper'
require 'democritus/class_builder/command'

module Democritus
  describe ClassBuilder::Command do
    subject { described_class.new(builder: nil) }
    it 'is abstract' do
      expect { subject.call }.to raise_error(NotImplementedError)
    end
  end
end
