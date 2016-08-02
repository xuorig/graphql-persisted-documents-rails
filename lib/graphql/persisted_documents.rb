require "graphql/persisted_documents/configuration"
require "graphql/persisted_documents/engine"
require "graphql/persisted_documents/persister"

module Graphql
  module PersistedDocuments
    @configuration = Configuration.new

    class << self
      attr_accessor :configuration

      def configure
        @configuration ||= Configuration.new
        yield(configuration) if block_given?
      end
    end
  end
end
