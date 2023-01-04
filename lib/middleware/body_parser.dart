import 'dart:io';
import 'dart:convert';

import 'package:iris/exceptions/decode_exception.dart';
import 'package:iris/core.dart';

class BodyParser extends Middleware {
  late ContentType contentType;

  @override
  void run(Request req, Response res) {
    contentType = req.headers.contentType ?? ContentType.binary;
    req.body = _decodeAny(req.rawData);
  }

  dynamic _decodeAny(String raw) {
    if (contentType.value == ContentType.text.value) {
      return _decodeRaw(raw);
    } else if (contentType.value == ContentType.json.value) {
      return _decodeJson(raw);
    } else if (contentType.value ==
        ContentType.parse('application/x-www-form-urlencoded').value) {
      return _decodeUrlEncodedFormData(raw);
    } else if (contentType.value == ContentType.binary.value) {
      return _decodeBinary(raw);
    } else {
      throw ParserUnknownTypeExcpetion();
    }
  }

  dynamic _decodeBinary(dynamic raw) => raw;

  String _decodeRaw(String raw) => raw;

  dynamic _decodeJson(String raw) => json.decode(raw);

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
