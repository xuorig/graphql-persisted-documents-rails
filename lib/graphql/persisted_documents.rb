require "graphql"

require "graphql/persisted_documents/configuration"
require "graphql/persisted_documents/version"
require "graphql/persisted_documents/rack"
require "graphql/persisted_documents/persister"

module Graphql
  module PersistedDocuments
    class << self
      attr_accessor :configuration

      def configure
        @configuration ||= Configuration.new
        yield(configuration) if block_given?
      end
    end
  end
end
