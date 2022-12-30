import 'dart:io';
import 'dart:convert';

export 'request.dart' show Request;

class Request {
  late String method;
  late HttpRequest request;
  late dynamic rawdata;
  late dynamic body = {};

  Request(this.request) {
    method = request.method;
  }

  Map<String, List<String>> get query => request.uri.queryParametersAll;
  String get fragment => request.uri.fragment;

  Map<String, dynamic> get headers {
    Map<String, dynamic> reqHeaders = {};
    request.headers.forEach((name, values) => reqHeaders[name] = values);
    return reqHeaders;
  }

  Future<void> getRaw() async {
    rawdata = await request.cast<List<int>>().transform(utf8.decoder).join();
  }
}
