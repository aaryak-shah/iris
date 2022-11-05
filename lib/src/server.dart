import 'dart:io';
import 'package:iris/src/middleware.dart';

import './router.dart';

class IrisServer {
  late int _port;
  late RouteTable _routes;
  late HttpServer server;

  IrisServer({required int port, required RouteTable routes}) {
    _port = port;
    _routes = routes;
  }

  Future<void> start() async {
    try {
      server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      await server.forEach((HttpRequest request) {
        List<String> segments = List.from(request.uri.pathSegments);
        segments.removeWhere((element) => element == "");
        List<Middleware> pathMiddleware = [];
        Route route = RouteTable.findRoute(
          pathSegments: segments,
          routeTable: _routes,
          pathMiddleware: pathMiddleware,
        );
        print("${request.uri.pathSegments}");
        print("$segments");
        route.handleRoute(request: request, pathMiddleware: pathMiddleware);
      });
    } catch (e) {
      rethrow;
    }
  }

  int get port => _port;
}

// website.com/home//profile