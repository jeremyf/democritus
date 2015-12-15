require 'spec_helper'

RSpec.describe Democritus do
  subject { described_class }
  its(:constants) { should include(:DemocritusObjectTag) }
end
