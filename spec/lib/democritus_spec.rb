require 'spec_helper'

RSpec.describe Democritus do
  subject { described_class }
  its(:constants) { should include(:DemocritusObjectTag) }
  its(:build) { should be_a(Class) }

  context 'an object instantiated from the built class' do
    subject { described_class.build.new }
    it 'should be a DemocritusObjectTag' do
      expect(subject).to be_a(Democritus::DemocritusObjectTag)
    end
  end
end
