require 'spec_helper'

describe Graphql::PersistedDocuments::Rack do
  include Rack::Test::Methods

  let(:app) do
    Graphql::PersistedDocuments::Rack.new(
      Graphql::PersistedDocuments::TestingRackApp.new
    )
  end

  before do
    ENV['RACK_ENV'] = "test"

    Graphql::PersistedDocuments.configuration = nil
    Graphql::PersistedDocuments.configure do |config|
      config.schema = TestSchema
    end
  end

  context "when no document param is present" do
    it "responds with a 422" do
      get '/persist'
      expect(last_response.status).to eq(422)
      expect(last_response.body).to eq("{\"errors\":[\"Missing required argument document\"]}")
    end
  end

  context "when the document is not parsable" do
    it "responds with an error" do
      get '/persist?document=query {'
      expect(last_response.status).to eq(422)
      expect(last_response.body).to eq("{\"errors\":[\"Unable to parse document\"]}")
    end
  end

  context "when the document is not valid according to Schema" do
    it "responds with validation errors" do
      get '/persist?document=query invalidQuery { invalidField }'
      expect(last_response.status).to eq(422)
      expect(last_response.body).to eq("{\"errors\":[{\"message\":\"Field 'invalidField' doesn't exist on type 'Query'\",\"locations\":[{\"line\":1,\"column\":1}]}]}")
    end
  end

  context "when the persit_validated_document proc is not configured" do
    before do
      Graphql::PersistedDocuments.configure do |config|
        config.persist_validated_document = nil
      end
    end

    it "responds with an error" do
      get '/persist?document=query invalidQuery { validField }'
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("{\"errors\":[\"persist_validated_document must be defined in config\"]}")
    end
  end

  context "when the query is valid" do
    before do
      Graphql::PersistedDocuments.configure do |config|
        config.persist_validated_document = lambda do |document|
          return 1 # Return a dummy id
        end
      end
    end

    it "responds with the document_id" do
      get '/persist?document=query invalidQuery { validField }'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("{\"document_id\":1}")
    end
  end

  context "when a custom path is set" do
    before do
      Graphql::PersistedDocuments.configure do |config|
        config.persist_validated_document = lambda do |document|
          return 1 # Return a dummy id
        end

        config.path = '/graphql/my/persist'
      end
    end

    it "responds at that endpoint" do
      get '/graphql/my/persist?document=query invalidQuery { validField }'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("{\"document_id\":1}")
    end
  end
end
