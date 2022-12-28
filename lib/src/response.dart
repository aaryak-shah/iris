import 'dart:io';
export 'response.dart' show Response;

class Response {
  bool sent = false;
  Response(HttpResponse response);
}
