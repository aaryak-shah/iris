import 'dart:io';
export 'response.dart' show Response;

class Response {
  late bool ok;
  Response(HttpResponse response);
}
