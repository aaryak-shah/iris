import 'dart:io';
import 'package:meta/meta.dart';
export 'request.dart' show Request;

class Request {

  late dynamic method; 
  late dynamic rawdata;
  late dynamic body = {};
  Request(HttpRequest request) async {

    method = request.method;
    rawdata = await request.cast<List<int>>().transform(utf8.decoder).join();
  }
}