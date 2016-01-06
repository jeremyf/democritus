require "bundler/gem_tasks"

unless Rake::Task.task_defined?('spec')
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = "./spec/**/*_spec.rb"
    end
  rescue LoadError
    $stdout.puts "RSpec failed to load; You won't be able to run tests."
  end
end

task(default: ['rubocop', 'spec'])

require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rspec'
  task.options << "--config=.hound.yml"
end
