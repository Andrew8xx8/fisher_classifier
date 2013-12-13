# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fisher_classifier/version'

Gem::Specification.new do |spec|
  spec.name          = "fisher_classifier"
  spec.version       = FisherClassifier::VERSION
  spec.authors       = ["Andrew8xx8"]
  spec.email         = ["avk@8xx8.ru"]
  spec.description   = %q{Light document classifier based on Fisher method}
  spec.summary       = %q{Light document classifier based on Fisher method}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "awesome_print"
end
