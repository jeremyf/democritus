if ENV['COV'] || ENV['COVERAGE'] || ENV['TRAVIS']
  if ENV['TRAVIS']
    require 'simplecov'
    require "codeclimate-test-reporter"
    SimpleCov.start do
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        CodeClimate::TestReporter::Formatter
      ])
    end
  elsif ENV['COV'] || ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start
  end
end
