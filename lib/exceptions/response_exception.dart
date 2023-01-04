import 'dart:core';

class ResponseException implements Exception {
  late String _msg;
  ResponseException(String msg) {
    _msg = msg;
  }

  @override
  String toString() {
    return _msg;
  }
}
