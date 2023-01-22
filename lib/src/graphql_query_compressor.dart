/// [compressGraphqlQuery] eliminate unnecessary characters from a GraphQL query.
/// You may use [GraphqlQueryCompressor] to inject this package and make your code testable
String compressGraphqlQuery(String query) =>
    GraphqlQueryCompressor.instance(query);

enum _CharType {
  letter,
  endOfWord,
  space,
  symbolThatDoesNotNeedSpace,
}

/// [GraphqlQueryCompressor] is a injectable version from [compressGraphqlQuery], it is specially designed for you, that like pretty codes
/// Since the code is executed by [call], you can use this class as an use case:
///
/// class MyClass{
///   final GraphqlQueryCompressor compressor;
///   MyClass(this.compressor);
///
///   void fun(String query){
///     final compressed = compressor(query);
///   }
///
class GraphqlQueryCompressor {
  // I know what you are thinking: "this guy doesn't know _Regex_" (...do you? 🤡)
  // There are some fancy implementations for this, like this popular one for JS: https://github.com/rse/graphql-query-compress/blob/master/src/graphql-query-compress.js
  // Question is: do we really need to compile 15 regexes, parse the query transforming it in a tree, eliminate unwanted elements and serialize it again?
  // We only want to eliminate some characters in a string, we can do it in a single for! Since this function is intent to be used on the fly, this seams to be faster
  // God bless you and I must seek forgiveness from my CC teachers.

  // since most apps will use it several times, we preserve an instance to keep all generated lists ready to go
  // remember: `static` in dart is lazy by default ;-)
  static final instance = GraphqlQueryCompressor._();

  final _symbolsThatDoNotNeedSpace = ["{", "}", "(", ")", ":", ",", "."]
      .map((e) => e.runes.first)
      .toList(growable: false);
  final _whiteSpace =
      [" ", "\t", "\n", "\r"].map((e) => e.runes.first).toList(growable: false);
  final _stringCharCode = "\"".runes.first;
  final _spaceCharCode = " ".runes.first;
  final _commentCharCode = "#".runes.first;
  final _newLineCharCode = "\n".runes.first;

  GraphqlQueryCompressor._();

  factory GraphqlQueryCompressor() => instance;

  bool _isLetter(int code) =>
      !_symbolsThatDoNotNeedSpace.contains(code) && !_whiteSpace.contains(code);

  bool _isWhiteSpace(int code) => _whiteSpace.contains(code);

  bool _isSymbolThatDoesNotNeedSpace(int code) =>
      _symbolsThatDoNotNeedSpace.contains(code);

  /// [call] compress a query, eliminating unwanted characters
  String call(String query) {
    final output = <int>[];
    _CharType lastReadChar = _CharType.space;

    bool isInsideAString = false;
    bool isInsideAComment = false;

    for (final code in query.runes) {
      if (isInsideAString) {
        if (code == _stringCharCode) {
          isInsideAString = false;
        }
        output.add(code);
        continue;
      }
      if (code == _stringCharCode) {
        isInsideAString = true;
        output.add(code);
        continue;
      }
      if (isInsideAComment) {
        if (code == _newLineCharCode) {
          isInsideAComment = false;
        }
        continue;
      }
      if (code == _commentCharCode) {
        isInsideAComment = true;
        continue;
      }

      if (!_isLetter(code) && lastReadChar == _CharType.letter) {
        lastReadChar = _CharType.endOfWord;
      }

      if (_isWhiteSpace(code)) {
        continue;
      }
      if (_isSymbolThatDoesNotNeedSpace(code)) {
        output.add(code);
        lastReadChar = _CharType.symbolThatDoesNotNeedSpace;
        continue;
      }
      if (_isLetter(code)) {
        if (lastReadChar == _CharType.endOfWord) {
          output.add(_spaceCharCode);
        }
        output.add(code);
        lastReadChar = _CharType.letter;
        continue;
      }
    }

    return String.fromCharCodes(output);
  }
}
