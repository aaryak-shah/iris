import 'dart:io';
import 'package:meta/meta.dart';
export 'request.dart' show Request;

class Request {

  late bool bodyUsed; 
  Request(HttpRequest request){

    bodyUsed = request.bodyUsed;
  }
}