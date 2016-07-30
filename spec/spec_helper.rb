require 'graphql/persisted_documents'

require 'rack/test'
require 'pry'

RSpec.configure do |config|
  config.order = :random
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class Graphql::PersistedDocuments::TestingRackApp
  def call(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

