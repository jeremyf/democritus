require 'spec_helper'

RSpec.describe Democritus do
  subject { described_class }
  its(:constants) { should include(:DemocritusObjectTag) }
  its(:build) { should be_a(Class) }
end
