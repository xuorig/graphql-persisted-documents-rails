module Graphql
  module PersistedDocuments
    class Persister
      InvalidDocument = Class.new(StandardError)
      MissingPersistValidatedDocument = Class.new(StandardError)
      ParseError = Class.new(StandardError)

      attr_reader :query_string, :errors

      def initialize(query_string)
        @query_string = query_string
        @errors = []
      end

      def persist!
        document = GraphQL.parse(query_string)
        query = GraphQL::Query.new(config.schema, document: document)
        perform_validation(query)

        raise InvalidDocument unless errors.empty?

        user_persister = config.persist_validated_document
        return user_persister.call(document) if user_persister

        raise MissingPersistValidatedDocument
      rescue GraphQL::ParseError
        raise ParseError
      end

      private

      def perform_validation(query)
        validation_result = validator.validate(query)
        @errors = validation_result[:errors]
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
