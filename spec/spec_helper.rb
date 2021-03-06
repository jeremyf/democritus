GEM_ROOT = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift File.join(GEM_ROOT, 'lib')

require 'democritus'
require 'rspec'
require 'rspec/its'
require 'shoulda/matchers'

Dir[File.join(GEM_ROOT, 'spec', 'support', '**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.order = :random

  config.include Shoulda::Matchers::Independent
  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand(config.seed)
end
