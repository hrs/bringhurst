# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bringhurst/version"

Gem::Specification.new do |spec|
  spec.name          = "bringhurst"
  spec.version       = Bringhurst::VERSION
  spec.authors       = ["Harry R. Schwartz"]
  spec.email         = ["hello@harryrschwartz.com"]

  spec.summary       = "Infer your methods' types and generate signatures."
  spec.homepage      = "https://github.com/hrs/bringhurst"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
