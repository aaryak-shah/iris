import 'dart:convert';

import 'package:iris/consts/content_type.dart';
import 'package:iris/exceptions/decode_exception.dart';
import 'package:iris/src/middleware.dart';
import 'package:iris/src/request.dart';
import 'package:iris/src/response.dart';

class BodyParser extends Middleware {
  final ContentType contentType;
  BodyParser({required this.contentType});

  @override
  void run(Request req, Response res) {
    req.body = _decodeAny(req.rawdata);
  }

  dynamic _decodeAny(String raw) {
    switch (contentType) {
      case ContentType.text_Plain:
        return _decodeRaw(raw);
      case ContentType.application_Json:
        return _decodeJson(raw);
      case ContentType.multipart_FormData:
        return _decodeMultiPartFormData(raw);
      case ContentType.application_UrlEncoded:
        return _decodeUrlEncodedFormData(raw);
      default:
        throw ParserUnknownTypeExcpetion();
    }
  }

  String _decodeRaw(String raw) {
    return raw;
  }

  dynamic _decodeJson(String raw) {
    return json.decode(raw);
  }

  Map<String, dynamic> _decodeMultiPartFormData(String raw) {
    Map<String, dynamic> formData = {};

    for (int i = 5; i < raw.length; i++) {
      if (raw.substring(i - 5, i) == "name=") {
        i++;
        int start = i;
        while (i < raw.length &&
            !((raw[i - 1] == '"' && raw[i] == '\r') ||
                (raw[i - 1] == '"' && raw[i] == ';'))) {
          i++;
        }
        int end = i - 1;
        String key = raw.substring(start, end);
        while (i < raw.length && !(raw[i - 1] == '\n' && raw[i] == '\r')) {
          i++;
        }
        String value = "";

        if (i < raw.length) {
          i += 2;
          start = i;
          while (raw[i] != '\r') {
            i++;
          }
          end = i;
          value = raw.substring(start, end);
        }
        formData[key] = value;
      }
    }

    return formData;
  }

  Map<String, dynamic> _decodeUrlEncodedFormData(String raw) {
    Map<String, dynamic> formData = {};
    List<String> parsedData = Uri.decodeComponent(raw).split('&');
    for (String data in parsedData) {
      String decodedData =
          Uri.decodeComponent(data.replaceAll(RegExp(r'\+'), '%20'));
      List<String> kvPair = decodedData.split('=');
      formData[kvPair[0]] = kvPair[1];
    }
    return formData;
  }
}
