import 'dart:io';
import 'dart:convert';

void main() async {
  HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 9999);
  server.forEach((HttpRequest request) async {
    String rawdata =
        await request.cast<List<int>>().transform(utf8.decoder).join();
    print(rawdata);
    request.response.write(rawdata);
    request.response.close();
  });
}
