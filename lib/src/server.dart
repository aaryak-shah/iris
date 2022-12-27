import 'dart:io';

import 'package:iris/src/middleware.dart';
import 'package:iris/src/router.dart';

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
      // define server
      server = await HttpServer.bind(InternetAddress.anyIPv4, port);

      // setup listener
      await server.forEach((HttpRequest request) {
        // calculate path segments
        List<String> segments = List.from(request.uri.pathSegments);
        segments.removeWhere((element) => element == "");

        // obtain route and middleware
        List<Middleware> pathMiddleware = [];
        Route route = RouteTable.findRoute(
          pathSegments: segments,
          routeTable: _routes,
          pathMiddleware: pathMiddleware,
        );

        print("${request.uri.pathSegments}");
        print("$segments");

        // execute targets
        route.handleRoute(
          request: request,
          response: request.response,
          pathMiddleware: pathMiddleware,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  int get port => _port;
}
