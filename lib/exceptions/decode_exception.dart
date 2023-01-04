import 'dart:core';

class ParserDecodeException implements Exception {
  String from;
  ParserDecodeException(this.from);

  @override
  String toString() {
    return "Failed to construct request body from $from. Received raw data may be invalid or corrupted.";
  }
}

class ParserUnknownTypeExcpetion implements Exception {
  late String _msg;
  ParserUnknownTypeExcpetion(
      [String msg =
          "Failed to decode. Received raw data has an unsupported type."]) {
    _msg = msg;
  }

  @override
  String toString() {
    return _msg;
  }
}
