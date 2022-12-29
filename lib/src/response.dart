import 'dart:convert' as convert;
import 'dart:io';

import 'package:iris/exceptions/response_exception.dart';
export 'response.dart' show Response;

class Response {
  bool sent = false;
  bool headersSet = false;
  late HttpResponse response;

  Future<void> send(String responseText) async {
    if(!sent){
      response.write(responseText);
      sent = true;
      headersSet = true;
      await response.flush();
      await response.close();
    }else {
      throw ResponseException("Response Already Sent!");
    }
  }

  void append(List<int> responseBytes){
    if(!headersSet){
      headersSet = true;
      response.headers.contentType 
        = ContentType("application", "octet-stream");
    }
    response.add(responseBytes);
  }

  Future<void> close() async {
    sent = true;
    await response.close();
  }

  void setStatus(HttpStatus status){
    // response.statusCode
  }

  Future<void> json(Map<String, dynamic> responseData) async {
    response.headers.contentType
      = ContentType("application", "json", charset: "utf-8");
    await send(convert.json.encode(responseData));
  }

  Response(this.response);
}
