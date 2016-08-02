module Graphql
  module PersistedDocuments
    class PersistedDocumentsController < ApplicationController
      def persist
        document = params[:document]

        unless document
          render_errors(['Missing required argument document'], status: 422)
          return
        end

        persister = Persister.new(document)
        document_id = persister.persist

        render json: { document_id: document_id }, status: :ok

      rescue Persister::ParseError
        render_errors(['Unable to parse document'], status: 422)
      rescue Persister::InvalidDocumentError
        render_errors(persister.errors, status: 422)
      rescue Persister::MissingPersistValidatedDocumentError
        render_errors(['persist_validated_document must be defined in config'])
      end

      private

      def render_errors(messages, status: 400)
        response = {
          errors: messages.map { |msg| { message: msg } }
        }

        render json: response, status: status
      end
    end
  end
end
