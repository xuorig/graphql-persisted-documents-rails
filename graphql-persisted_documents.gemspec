$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graphql/persisted_documents/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graphql-persisted_documents"
  s.version     = Graphql::PersistedDocuments::VERSION
  s.authors     = ["xuorig"]
  s.email       = ["mgiroux0@gmail.com"]
  s.homepage    = "http://mgiroux.me"
  s.summary     = "Rails Engine enabling an endpoint to persist GraphQL documents and retrieve a unique id"
  s.description = "Rails Engine enabling an endpoint to persist GraphQL documents and retrieve a unique id"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "graphql", "~> 0.17.0"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
