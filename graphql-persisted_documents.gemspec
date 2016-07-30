# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/persisted_documents/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-persisted_documents"
  spec.version       = Graphql::PersistedDocuments::VERSION
  spec.authors       = ["Marc-Andre Giroux"]
  spec.email         = ["mgiroux0@gmail.com"]

  spec.summary       = %q{Persisted GraphQL documents for Rack applications}
  spec.description   = %q{Rack middleware enabling an endpoint to persist GraphQL documents}
  spec.homepage      = "http://mgiroux.me"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "graphql", "~> 0.17.2"

  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rack-test", "~> 0.6.3"
  spec.add_development_dependency "rake", "~> 10.0"
end
