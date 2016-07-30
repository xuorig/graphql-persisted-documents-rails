module Graphql
  module PersistedDocuments
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'] == '/persist'
          request = ::Rack::Request.new(env)
          document = request.params['document']

          unless document
            return error_response(422, ['Missing required argument document'])
          end

          persister = Persister.new(document)
          document_id = persister.persist!

          [
            '200',
            {'Content-Type' => 'application/json'},
            [ { document_id: document_id }.to_json ]
          ]
        else
          @app.call(env)
        end
      rescue Persister::ParseError
        error_response(422, ['Unable to parse document'])
      rescue Persister::InvalidDocument
        error_response(422, persister.errors)
      rescue Persister::MissingPersistValidatedDocument
        error_response(400, ['persist_validated_document must be defined in config'])
      end

      private

      def error_response(code, errors)
        [
          code,
          {'Content-Type' => 'application/json'},
          [ { errors: errors }.to_json ]
        ]
      end
    end
  end
end
