
import 'package:graphql_query_compress/graphql_query_compress.dart';

void main() {
  const query = r'''
    mutation CreateShow($input: CreateShowInput!) {
      createShow(input: $input) {
        show {
          id # we need this ID to buy a ticket
          __typename
        }
        __typename
      }
    }
    ''';
    final compressedQuery = compressGraphqlQuery(query);
    print(compressedQuery);
    // output: "mutation CreateShow($input:CreateShowInput!){createShow(input:$input){show{id __typename}__typename}}"

}
