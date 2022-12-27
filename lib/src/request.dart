import 'dart:io';
import 'dart:convert';

export 'request.dart' show Request;

class Request {
  late String method;
  late dynamic rawdata;
  late dynamic body = {};
  Request(HttpRequest request) {
    method = request.method;
    // TODO: (fix) await for type transformation
    rawdata = /* await */ request
        .cast<List<int>>()
        .transform(utf8.decoder)
        .join();
  }
}
