require 'spec_helper'
require 'democritus/class_builder/command'
require 'shoulda/matchers'

describe Democritus::ClassBuilder::Command do
  subject { described_class.new(builder: nil) }
  it 'is abstract' do
    expect { subject.call }.to raise_error(NotImplementedError)
  end

  it { should delegate_method(:defer).to(:builder) }
end
