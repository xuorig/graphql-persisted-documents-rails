Rails.application.routes.draw do
  mount Graphql::PersistedDocuments::Engine => "/graphql"
end
