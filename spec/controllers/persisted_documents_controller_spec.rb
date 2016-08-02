require "rails_helper"

describe Graphql::PersistedDocuments::PersistedDocumentsController do
  routes { Graphql::PersistedDocuments::Engine.routes }

  describe "POST persist" do
    before do
      Graphql::PersistedDocuments.configure do |config|
        config.schema = TestSchema
        config.persist_validated_document = lambda do |document|
          'yolo-swag'
        end
      end
    end

    it "parses, validates and persists a document" do
      post :persist, params: { document: 'query { validField }' }

      expect(response.code).to eq("200")
      expect(response.body).to eq({
        document_id: 'yolo-swag'
      }.to_json)
    end


    context "when no params are passed in" do
      it "responds with an error" do
        post :persist, params: {}

        expect(response.code).to eq("422")
        expect(response.body).to eq({
          errors: [{
            message: "Missing required argument document"
          }]
        }.to_json)
      end
    end

    context "when the document is not parsable" do
      it "responds with an error" do
        post :persist, params: { document: "query {" }

        expect(response.code).to eq("422")
        expect(response.body).to eq({
          errors: [{
            message: "Unable to parse document"
          }]
        }.to_json)
      end
    end

    context "when the document is invalid according to schema" do
      it "responds with an error" do
        post :persist, params: { document: "query { invalidField }" }

        expect(response.code).to eq("422")
        expect(response.body).to eq({
          errors: [{
            message: "Field 'invalidField' doesn't exist on type 'Query'"
          }]
        }.to_json)
      end
    end

    context "when the persist_validated_document fn is not set" do
      before do
        Graphql::PersistedDocuments.configure do |config|
          config.schema = TestSchema
          config.persist_validated_document = nil
        end
      end

      it "responds with an error" do
        post :persist, params: { document: "query { validField }" }

        expect(response.code).to eq("400")
        expect(response.body).to eq({
          errors: [{
            message: "persist_validated_document must be defined in config"
          }]
        }.to_json)
      end
    end
  end
end
