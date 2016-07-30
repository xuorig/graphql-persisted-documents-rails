QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "Query root of the system"
  field :validField, types.String do
    resolve ->(_, _, _) { 'testValue' }
  end
end

TestSchema = GraphQL::Schema.new(
  query: QueryType
)
