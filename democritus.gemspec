# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'democritus/version'

Gem::Specification.new do |spec|
  spec.name          = "democritus"
  spec.version       = Democritus::VERSION
  spec.authors       = ["Jeremy Friesen"]
  spec.email         = ["jeremy.n.friesen@gmail.com"]

  spec.summary       = %q{A placeholder for an attribute declaration mechanism}
  spec.description   = %q{A placeholder for an attribute declaration mechanism}
  spec.homepage      = "https://github.com/jeremyf/democritus"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "flay"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
end
