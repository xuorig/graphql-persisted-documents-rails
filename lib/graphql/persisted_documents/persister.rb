module Graphql
  module PersistedDocuments
    class Persister
      InvalidDocumentError = Class.new(StandardError)
      MissingPersistValidatedDocumentError = Class.new(StandardError)
      ParseError = Class.new(StandardError)

      attr_reader :query_string, :errors

      def initialize(query_string)
        @query_string = query_string
        @errors = []
      end

      def persist
        document = GraphQL.parse(query_string)
        query = GraphQL::Query.new(config.schema, document: document)
        perform_validation(query)

        raise InvalidDocumentError unless errors.empty?

        user_persister = config.persist_validated_document
        return user_persister.call(document) if user_persister

        raise MissingPersistValidatedDocumentError
      rescue GraphQL::ParseError
        raise ParseError
      end

      private

      def perform_validation(query)
        validation_result = validator.validate(query)
        validation_errors = validation_result[:errors] || []
        @errors = validation_errors.map { |error| error["message"] }
      end

      def config
        PersistedDocuments.configuration
      end

      def validator
        GraphQL::StaticValidation::Validator.new(schema: config.schema)
      end
    end
  end
end
