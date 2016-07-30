# Graphql::PersistedDocuments

### What is a GraphQL Document ?

From the GraphQl spec:

> A GraphQL document is defined as a syntactic grammar where terminal symbols are tokens (indivisible lexical units). These tokens are defined in a lexical grammar which matches patterns of source characters (defined by a double‐colon ::)

### Persisted Documents

In most client side applications, the GraphQL requests are static. There is a limited set of them in an app and they chances are they wont change during the lifetime of the app. If they are not going to change, why not cache them server side, and simply call them by an id instead of sending a potentially huge query server side each time ?

This is what Graphql::PersistedDocuments allows you to do. At build time / deploy time, a client side can send all it's documents to a special endpoint, called `/persist` in this case. The GraphQL backend simply returns a `document_id` which allows every client side running application to call the server using an id instead of a full query_stirng.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-persisted_documents'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-persisted_documents

## Usage

`GraphQL::PersistedDocuments` is simply a Rack Middleware defined as `Graphql::PersistedDocuments::Rack`. To use it in Rails for example:

```ruby
module YourApp
  class Application < Rails::Application

    # ...

    # Rails 3/4
    config.middleware.insert_before 0, "Graphql::PersistedDocuments::Rack"

    # Rails 5
    config.middleware.insert_before 0, Rack::Cors
  end
end
```

## Configuring

The middleware currently required two things to be defined in the config:

  - `config.schema`: A GraphQL Schema, defined by the `graphql` gem.
  - `config.persit_validated_document`: An object that responds to `call`, which returns an id in exchange of a parsed GraphQL Document.

To configure, for example in a Rails app:

```ruby
Graphql::PersistedDocuments.configure do |config|
  config.schema = ShopSchema
  config.persist_validated_document = lambda do |document|
    uuid = SecureRandom.uuid
    Rails.cache.write(uuid, document)
    uuid
  end
end
```

## Using with Rails

When using with `rails` and `graphql` gems. We can simply accept a `document_id` as a param, as well as the standard `query` param.

If we receive a `document_id`, we can retrieve that id from a store, cache, database, depending on how you implemented `persist_validated_document`.

Example controller:


```ruby
class GraphqlController < ApplicationController
  def execute
    query_string = params[:query]
    document_id = params[:document_id]
    variables = params[:variables]

    raise SomeGraphQLError unless query_string || document_id

    if document_id
      result = execute_from_persisted_document(document_id, variables)
    else
      result = execute_from_query_string(query_string, variables)
    end

    render json: result
  end

  private

  def execute_from_query_string(query_string, variables)
    MySchema.execute(query_string, variables: variables)
  end

  def execute_from_persisted_document(document_id, variables)
    persisted_document = get_persisted_document(document_id)
    MySchema.execute(document: persisted_document, variables: variables)
  end

  def get_persisted_document(document_id)
    Rails.cache.fetch(document_id)
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xuorig/graphql-persisted_documents. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

