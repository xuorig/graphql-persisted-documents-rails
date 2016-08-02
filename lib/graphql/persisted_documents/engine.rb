module Graphql
  module PersistedDocuments
    class Engine < ::Rails::Engine
      isolate_namespace Graphql::PersistedDocuments

      config.generators do |g|
        g.test_framework :rspec
      end
    end
  end
end
