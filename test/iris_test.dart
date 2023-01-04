import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:iris/core.dart';
import 'package:iris/utils.dart';
import 'package:test/test.dart';

class TestRoute extends Route {
  TestRoute(String name, {List<Middleware> middleware = const []})
      : super(name, middleware: middleware);

  @override
  Future<void> get(Request req, Response res) async {
    await res.send('Test');
  }

  @override
  Future<void> post(Request req, Response res) async {
    // print(req.body);
    await res.json({'msg': req.body['username']});
  }
}

RouteTable route = RouteTable(
  routes: {
    '/test': RouteTable(
      routes: {'/a/b/': TestRoute('/')},
      middleware: [
        BodyParser(),
      ],
    )
  },
);

void main() {
  late IrisServer server;
  const port = 5000;

  server = IrisServer(port: port, routes: route);
  server.start();

  test('Server port is correct', () => expect(server.port, port));

  test('GET request works', () async {
    final res =
        await http.get(Uri.parse('http://localhost:${server.port}/test/a/b/'));
    expect(res.statusCode, HttpStatus.ok);
    expect(res.headers['content-type'], 'text/plain; charset=utf-8');
    expect(res.body, 'Test');
  });

  test('GET request on undefined route returns 404 Not Found', () async {
    final res = await http
        .get(Uri.parse('http://localhost:${server.port}/doesnotexist'));
    expect(res.statusCode, HttpStatus.notFound);
    expect(res.headers['content-type'], 'text/plain; charset=utf-8');
    expect(res.body, '404: Not Found');
  });

  test('PATCH request returns 404 Not Found', () async {
    final res =
        await http.patch(Uri.parse('http://localhost:${server.port}/test'));
    expect(res.statusCode, HttpStatus.notFound);
    expect(res.headers['content-type'], 'text/plain; charset=utf-8');
    expect(res.body, '404: Not Found');
  });

  test('POST request with body works', () async {
    final res = await http.post(
      Uri.parse('http://localhost:${server.port}/test/a/b'),
      body: json.encode({'username': 'test'}),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    expect(res.statusCode, HttpStatus.ok);
    expect(res.headers['content-type'], 'application/json; charset=utf-8');
    expect(json.decode(res.body)['msg'], 'test');
  });
}
