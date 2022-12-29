import 'dart:io';
import 'dart:convert';

export 'request.dart' show Request;

class Request {
  late String method;
  late HttpRequest request;
  late dynamic rawdata;
  late Map<String, dynamic> headers;
  late dynamic body = {};
  Request(this.request) {
    method = request.method;
  }

  Future<void> getRaw() async {
    rawdata = await request.cast<List<int>>().transform(utf8.decoder).join();
  }
}
