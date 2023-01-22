![flutter-ci](https://github.com/talesbarreto/graphql_query_compress/actions/workflows/flutter-ci.yml/badge.svg)
Package that eliminates unnecessary characters from a GraphQL query, saving several bytes on requests.

```dart
final compressedQuery = compressGraphqlQuery(query);
```
see example for input and output sample

## Using it with `gql_dio_link`, `gql_http_link` or `graphql`

GQL [will serialize your query in a human-readable format](https://github.com/gql-dart/gql/blob/master/gql/lib/src/language/printer.dart#L185) after parse it to DocumentNodes. Therefore, we can't simple compress it before use `GQL` parser.

To ~~workaround~~ overcome this, we need to replace GQL `RequestSerializer` by `RequestSerializerWithCompressor`

```dart
return GraphQLClient(
  cache: GraphQLCache(store: null),
  link: HttpLink(
    _apiUrl,
    serializer: const RequestSerializerWithCompressor(),
  ),
);
```
Same deal with DioLink:

```dart
final link = DioLink(
  _apiUrl,
  client: Dio(),
  useGETForQueries: true,
  serializer: MyRequestSerializer(),
);
``` 