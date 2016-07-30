module Graphql
  module PersistedDocuments
    class Configuration
      DEFAULT_PATH = '/persist'

      attr_accessor(
        :schema,
        :persist_validated_document,
        :path
      )

      def initialize
        @path = DEFAULT_PATH
      end
    end
  end
end
