Graphql::PersistedDocuments::Engine.routes.draw do
  post '/persist', to: 'persisted_documents#persist'
end
