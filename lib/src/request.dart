import 'dart:io';
import 'dart:convert';

export 'request.dart' show Request;

class Request {
  late HttpRequest request;
  late dynamic rawData;
  dynamic body = {};
  Map<String, String> params = {};

  Request(this.request);

  String get method => request.method;
  Map<String, List<String>> get query => request.uri.queryParametersAll;
  String get fragment => request.uri.fragment;
  HttpHeaders get headers => request.headers;

  // Map<String, dynamic> get headers {
  //   Map<String, dynamic> reqHeaders = {};
  //   request.headers.contentType;
  //   request.headers.forEach((name, values) => reqHeaders[name] = values);
  //   return reqHeaders;
  // }

  Future<void> getRaw() async {
    rawData = await request.cast<List<int>>().transform(utf8.decoder).join();
  }
}
