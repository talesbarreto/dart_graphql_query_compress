![flutter-ci](https://github.com/talesbarreto/dart_graphql_query_compress/actions/workflows/flutter-ci.yml/badge.svg)

This package eliminates unnecessary characters from a GraphQL query, saving several bytes on requests.

```dart
final compressedQuery = compressGraphqlQuery(query);
```

## Using it with `gql_dio_link`, `gql_http_link` or `graphql`

GQL [will serialize your query in a human-readable format](https://github.com/gql-dart/gql/blob/master/gql/lib/src/language/printer.dart#L185) after parse it to DocumentNodes. Therefore, we can't simple compress it before using the `GQL` parser.

To overcome this, we need to replace GQL `RequestSerializer` by `RequestSerializerWithCompressor`

```dart
return GraphQLClient(
  cache: GraphQLCache(store: null),
  link: HttpLink(
    _apiUrl,
    serializer: const RequestSerializerWithCompressor(),
  ),
);
```
The same applies to DioLink:

```dart
final link = DioLink(
  _apiUrl,
  client: Dio(),
  useGETForQueries: true,
  serializer: const RequestSerializerWithCompressor(),
);
```
